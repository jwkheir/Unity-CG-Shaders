//Author: Jack Kheir
//Course: Games Development BSC
//Module: C0569 GPU Programming and Shaders 
//Assignment: CW1

Shader "Custom/FlagAnimationShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		//The frequency of waves produced
		_Frequency("Frequency", float) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		
		//Shader property variables
		float4 _Color;
		sampler2D _MainTex;
		float _Frequency;

		struct Input {
			//Takes Color Input in the inspector and passes to surf to use
			float4 color : Color;
			float2 uv_MainTex;
		};
		
		void vert(inout appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input,o);
			//the elapsed time passed to sin to create a sin wave
			//You can adjust the frequency to speed up or slow the fequency of the sine wave
			float time = _Time * _Frequency;
			//The y offset used to offset the verticies
			float offset = v.vertex.y;
			
			//sets the y axis vertices
			//assigns the output y vertex the texture coord x value * by sin(vertex x + time) to generate a sine wave
			v.vertex.y = v.texcoord.x * sin(v.vertex.x + time);
			
			//Uncomment these two lines for a different effect 
			
			//appends to the y vertex an additional sine wave
			//v.vertex.y += sin(v.vertex.z / 2  + time);
			//v.vertex.y *= v.vertex * 0.1f;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			//Assign the _ColorTint
			IN.color = _Color;
			
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * IN.color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
