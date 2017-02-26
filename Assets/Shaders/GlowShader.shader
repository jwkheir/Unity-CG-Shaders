
//Author: Jack Kheir
//Course: Games Development BSC
//Module: C0569 GPU Programming and Shaders 
//Assignment: CW1

//Description: A Surface Shader that applies a Glow effect to the object the SurfaceGlowMaterial that is attached
Shader "Custom/GlowShader" {
	Properties {
		//Defines a Color property within the inspector
		//Colour Tint - Default to white
		_Color("Tint", Color) = (1, 1, 1 ,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}

		//Defines a Spec Power property within the inspector
		//Defines a slider within the inspector from 0 to 1
		_SpecPower("Specular Power", Range(0, 1)) = 0.5
		//Defines a Spec Map property within the inspector
		//Spec Map - 2D Texture
		_SpecMap("Specular Map", 2D) = "black" {}
		//Defines a Rim Color property within the inspector
		//Illuminated Color on outside edges defined by the color in the inspector property
		_RimColor("Rim Color", Color) = (1, 1, 1, 1)
		//Defines a Rim Power property within the inspector
		//Range Slider between 1.0 and 6.0 - Default set to 3.0 that defines the rim strength/power
		_RimPower("Rim Power", Range(0.01, 3.0)) = 1.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf BasicLambertRim
		
		//Shader Properties Variables
		float4 _Color;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _SpecMap;
		float _SpecPower;
		float4 _RimColor;
		float _RimPower;
		
		struct Input {
			//Takes Color Input in the inspector and passes to surf to use
			float4 color : Color;
			float2 uv_MainTex;
			//X & Y Offset for tiling
			float2 uv_BumpMap;
			float2 uv_SpecMap;
			//Used for camera - i.e. when camera is facing
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			
			//Assign the _ColorTint
			IN.color = _Color;
			//Surface output
			//_ColorTint will affect texture
			//will bring down the brightness from the lighting model also
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * IN.color;
			fixed4 specTex = tex2D(_SpecMap, IN.uv_SpecMap);
			
			//Rim effect - Creates colour  based on Camera position
			//Determines what color should look like whenever it's perpindicular to the surface of material
			//By Setting subtracting it the colour will appear on the outside edge 
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			//Sets the emission output for the Glow effect by assigning the RimColor rgb values and * it by the calculated rim to the power of _RimCo 
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
			//assigns the specular amount through the spec power property 
			o.Specular = _SpecPower;
			//assign the gloss amount by assigning it the specular texture rgb values 
			o.Gloss = specTex.rgb; 
		}
		
		inline fixed4 LightingBasicLambertRim(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			//Half vector between light and view direction
			float3 h = normalize(lightDir + viewDir);
		
			//Calculate Diffuse lighting
			//Clamps between 0 and highest value of dot product
			//angle between surface normal and light direction
			fixed NDotL = max(0, dot(s.Normal, lightDir));
			
			//Normal dot half vector fall off vector i.e. rim lights the object where a light is placed/seen
			fixed NDotH = max(0, dot(s.Normal, h));
			//Normal dot View Dir/ Eye Dir
			fixed NDotE = max(0, dot(s.Normal, viewDir));
			
			//Lambert 
			//Halfing the values then adding 5 to make it lighter
			//To take the brightness down we raise to a power of two
			fixed lambert = pow((NDotL * 0.5 + 0.5), 2.0);
			
			//Rim light calculation
			//Inverts the falloff by negating the nDote 
			fixed rimLight = 1 - NDotE; 
			//Clamps the rimLight by raising it to a power
			rimLight = pow(rimLight, _RimPower) * NDotH;
			
			fixed4 finalColor;
			//Brings in surf input modifications in to final color
			//Used to determine the final color
			finalColor.rgb = (s.Albedo * _LightColor0.rgb + rimLight) * (lambert * atten * 2);
			//Set the alpha
			finalColor.a = 0.0;
			//returns the final color
			return finalColor; 
			
			
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
