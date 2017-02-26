
//Author: Jack Kheir
//Course: Games Development BSC
//Module: C0569 GPU Programming and Shaders 
//Assignment: CW1
Shader "Custom/AudioVisualizerShader" {
	Properties {
		//Top & Bottom blended colour by changing the value it will be applied in the lerp to create a kind of gradient
		_TopColour("Top Blend Colour", Color) = (1,1,1,1)
		_BottomColour("Bottom Blend Colour", Color) = (1,1,1,1)
		//Frequency value defined bu the CubeAudioVisualizer script that gets the frequency from the audio samples
		_Frequency("Frequency", float) = 0
		_BlendAmount("Blend Amount", Range(0, 10)) = 5
	}
	SubShader {
		//vertex:vert specified for a vert shader
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		
		//Corresponding shader propety variables
		float4 _TopColour;
		float4 _BottomColour;
		float _Frequency;
		float _BlendAmount;
		
		struct Input {
			float4 trash;
			//float3 vertColor input value
			//the vert function will assign this a value, which in turn will be passed to the surf function
			//as the vert function gets called first
			float3 vertColor;
		};
		
		void vert(inout appdata_full v, out Input o){
			//For compatability issues
			UNITY_INITIALIZE_OUTPUT(Input,o);
			//defines a float to hold the time to be used in the sine wave
			//the frequency property gets upadated within the cubevisualizer script 
			float time = _Time * _Frequency;
			//As i want to maniupulate the y -axis i need to define an offset to pass in the sin function
			float offset = -v.vertex.y;
			float height = sin(time + offset) * _BlendAmount;
			//I create a colour from the height variable and assign it to the vertColor variable which then gets sent back out 
			//to finally the surf function
			o.vertColor = float3(height, height, height);
		}


		void surf (Input IN, inout SurfaceOutput o) {
			//I then lerp the property values with the vertcolor to create a cool gradient kind of effect
			o.Albedo = lerp (_TopColour, _BottomColour, IN.vertColor).rgb;
			//Setting the alpha 
			o.Alpha = 1.0;
		}
		ENDCG
	} 

	FallBack "Diffuse"
}
