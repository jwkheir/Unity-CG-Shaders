
//Author: Jack Kheir
//Course: Games Development BSC
//Module: C0569 GPU Programming and Shaders 
//Assignment: CW1

//Description: A Surface Shader that applies a Emissive effect to the object the EmissiveMaterial that is attached
Shader "Custom/AudioEmissiveShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//Defines a Bump Map property within the inspector
		//Normal Map - 2D Texture
		_BumpMap("Normal Map", 2D) = "bump" {} 
		//Defines a Spec Map property within the inspector
		//Spec Map - 2D Texture
		_SpecMap("Specular Map", 2D) = "black" {}
		//Defines a Spec Color property within the inspector
		//Color float4
		_SpecColor("Specular Color", Color) = (0.5, 0.5, 0.5, 1.0)
		//Defines a Spec Power property within the inspector
		//Defines a slider within the inspector from 0 to 1
		_SpecPower("Specular Power", Range(0, 1)) = 0.5
		//Defines a Emit Map property within the inspector
		//Emit Map - 2D Texture
		_EmitMap("Emit Map", 2D) = "black" {}
		//Defines a slider within the inspector from 0 to 2
		_EmitPower("Emit Power", Range(0, 10)) = 5.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf BlinnPhong
		
		//Shader Properties Variables
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _SpecMap;
		float _SpecPower;
		sampler2D _EmitMap;
		float _EmitPower;
		
		struct Input {
			float2 uv_MainTex;
			//X & Y Offset for tiling
			float2 uv_BumpMap;
			float2 uv_SpecMap;
			float2 uv_EmitMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
	
			//Defines the main texture, specular map and emit map
			fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 specTex = tex2D(_SpecMap, IN.uv_SpecMap);
			fixed4 emitTex = tex2D(_EmitMap, IN.uv_EmitMap);
			
			//Sets the 
			o.Albedo = mainTex.rgb;
			//Unpacks the bump map
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			//Assigns the spec power through the property value
			o.Specular = _SpecPower;
			//Assigns the gloss value from the specular texture
			o.Gloss = specTex.rgb; 
			//Assigns the emission through the emit texture rgb * the emit power property
			o.Emission = emitTex.rgb * _EmitPower;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
