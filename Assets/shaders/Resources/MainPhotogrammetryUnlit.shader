﻿Shader "Unlit/MainPhotogrammetryUnlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
				uint   vid    : SV_VertexID;
            };

            struct v2f
            {
                float2 uv     : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

			struct _Vertex {
				float3 position;
				float3 velocity;
				float2 uv;
			};

			struct _Index {
				int vertexID;
			};

			StructuredBuffer<_Vertex>  _VertexBuffer;

            sampler2D _MainTex;
            float4    _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;

				_Vertex vInfo  = _VertexBuffer[v.vid];

                o.vertex = UnityObjectToClipPos(float4(vInfo.position.xyz, 1.));
                o.uv = vInfo.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}