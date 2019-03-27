Shader "Custom/Block"
{
    Properties {
        _Color ("Tint", Color) = (1,1,1,1)
        _ROTATION ("ROTATION", RANGE(-360, 360)) = 45
        _AA_WIDTH ("AA Width", RANGE(0, 0.2)) = 0.015
	}

	SubShader
	{
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
                    
            static float _RADIUS = 0.073;
            // static float _AA_WIDTH = 0.008;
            // static float _AA_WIDTH = 0.015;
            float _AA_WIDTH;
            float _ROTATION;
            fixed4 _Color;

            float4 RotateAroundYInDegrees (float4 vertex, float degrees)
            {
                float radians = degrees * UNITY_PI / 180.0;
				float sin, cos;
				sincos( radians, sin, cos );
				float2x2 m = float2x2( cos, -sin, sin, cos );

                // xx, xy, xz, xw, yx, yy, yz, yw, zx, zy, zz, zw, wx, wy, wz, ww;

                return float4(mul(m, vertex.xy), vertex.zw).xyzw;
            }

            struct VertexInput {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
            };

            struct VertexOutput {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };
            
            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;

                // v.vertex *= 1.5;

                o.pos = UnityObjectToClipPos(
                    RotateAroundYInDegrees(
                        v.vertex,
                        _ROTATION
                    )
                );

                o.uv = v.uv - 0.5;
                o.uv /= 1.5;

                return o;
            }

            float udRoundRect(float2 p, float2 b, float r)
            {
	            return length(max(abs(p) - b, 0.0)) - r;
            }

            fixed4 frag(VertexOutput vertex_output) : SV_Target
            {
                // float radius = 0.1;
                // float radius = 0.073;

                // float usedAA = smoothstep(0, _AA_WIDTH, _ROTATION)
                float usedAA = clamp(
                    abs(_ROTATION) / 4,
                    // fmod(90, _ROTATION) / 45,
                    // fmod(_ROTATION, 90) / 45,
                    // abs(mod(_ROTATION, 90)) / 45,
                    // abs(fmod(_ROTATION, 90)) / 45,
                    // 0.0001,
                    0.5,
                    1.0
                ) * _AA_WIDTH;

                return smoothstep(
                    // _RADIUS + _AA_WIDTH,
                    _RADIUS + usedAA,
                    _RADIUS,
                    udRoundRect(
                        vertex_output.uv * 1.588,
                        (0.5 - _RADIUS) - _RADIUS,
                        _RADIUS
                    )
                ) * _Color;
            }
        ENDCG
        }
    }
}