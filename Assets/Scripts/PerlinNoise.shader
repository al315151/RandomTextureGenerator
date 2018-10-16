Shader "Custom/PerlinNoise"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseScale ("Noise Scale", float) = 5.0
		_NoiseDimension("Noise Dimension", float) = 500.0
	}
	SubShader
	{
		Tags { "RenderType"="Cutout" }
		LOD 100
	
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			float _NoiseScale;
			float _NoiseDimension;

			float random(float2 input)
			{
				return frac(sin(
					dot(input.xy, float2(12.9898, 78.2323))) *
					43758.543123);
			}

			float noise(float2 input)
			{
				float2 i = floor(input);
				float2 f = frac(input);


				float a = random(input);
				float b = random(input + float2(1.0, 0.0)) ;
				float c = random(input + float2(0.0, 1.0)) ;
				float d = random(input + float2(1.0, 1.0));

				//Cubic Hermine curve
				float2 u = f * f*(3.0 - 2.0*f);

				return lerp(b, c, u.x ) + (c - a) * u.y * (1.0 - u.x) +
					(d - b) * u.x * u.y;

			}
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.y += _Time.y;
				o.uv.x -= _Time.y;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
					
				//float noiseColor = noise(((_NoiseDimension * _NoiseDimension) / i.uv ) * _NoiseScale);
				//

				float noiseColor = random((_NoiseDimension * _NoiseDimension) / i.uv * _NoiseScale);

				return float4(noiseColor * col.r, noiseColor* col.g,
							  noiseColor * col.b, col.a);
			}
				
			ENDCG
		}
	}
}
