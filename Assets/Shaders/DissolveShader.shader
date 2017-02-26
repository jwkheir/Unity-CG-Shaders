Shader "Custom/DissolveShader" {
	Properties {
		//Main texture that will use to swap for 
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//This bump map will define the dissolve shape
		_DissolveMap("Dissolve Map", 2D) = "white" {}
		//dissolve value - the value in which to dissolve by
		_DissolveValue("Dissolve Value", Range(-0.2, 1.2)) = 1.2
		//The width of dissolved edges 
		_EdgeWidth("Edge Width", Range(0.0, 0.2)) = 0.1
		//The color of the dissolved edges
		_EdgeColor("Edge Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader {
		//Inform unity to colour fragments transparent
		Tags { "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		
		//Shader property variables
		sampler2D _MainTex;
		sampler2D _DissolveMap;
		float _DissolveValue;
		float _EdgeWidth;
		float4 _EdgeColor;

		struct Input {
			float2 uv_MainTex;
			float2 uv_DissolveMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			//Main Texture
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			//Dissolve texture
			half4 d = tex2D (_DissolveMap, IN.uv_DissolveMap);
			
			//The transparent amount to apply
			half4 transparent = half4(0, 0, 0, 0);
			
			//if the red value within the dissolve map is above the value of the _DissolveValue we will apply the edge colour
			//else red value is above the _DissolveValue and Edgewidth make it transparent
			
			//if red < dissolve value + edgewidth 
			int isTransparent = int(d.r - (_DissolveValue + _EdgeWidth) + 0.99);
			//else 0 if main texture instead of transparency or edge color
			int isEdge = int(d.r - (_DissolveValue) + 0.99);
			
			//determine whether to colour edges or make texture transparent
			
			half4 colorEdge = lerp(_EdgeColor, transparent, isTransparent);
			
			o.Albedo = lerp(o.Albedo, colorEdge, isEdge);
			
			//Defines the transparency of fragment
			o.Alpha = lerp(1.0, 0.0, isTransparent);
			
			
		}
		ENDCG
	} 
	//FallBack "Diffuse"
}
