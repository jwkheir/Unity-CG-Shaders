Shader "Custom/PixelateShader" {
	Properties {
		//The texture to apply the pixelation to
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_PixelCellSize("Pixelated Cell Size", vector) = (-0.04, -0.07, 0, 0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass
		{
			CGPROGRAM
			//define shaders
			#pragma vertex vert_img
			#pragma fragment frag
			//include UnityCG that holds vert_img
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _PixelCellSize;
			
			//v2f struct provides vertex data that then gets passed to the fragment function
			struct v2f 
			{
				//Vertex position
				float4 pos : SV_POSITION;
				//Texture UV cooridnate
				float4 texCord : TEXCOORD0;
			};
			
			//returns the struct variables i.e. o pos and o. texCord
			v2f vert(inout appdata_full v)
			{
				//Define the struct output
				v2f o;
				//for compatability issues 
				UNITY_INITIALIZE_OUTPUT(v2f,o);

				//assign the vertex position in the struct by multiplying a matrix by a the column vector/vertex 
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				//assign the tex coord in the struct the value of vertex position
				o.texCord = o.pos;
				//return o
				return o;
			}
			
			
			//pass the v2f sturct values i.e. pos and texcoord 
			float4 frag(v2f IN) : COLOR 
			{
				//Declare half2 variable to hold proccessed uv data i.e. the INput texcoord xy and w values
				half2 processedUV = IN.texCord.xy / IN.texCord.w;
				//divide procssedUV by the pixelcellsize xy values (inspector)
				processedUV /= _PixelCellSize.xy;
				//round the processedUV
				processedUV = round(processedUV);
				//Multiply processedUV by the x & values stored in pixcelcellsize
				processedUV *= _PixelCellSize.xy;
				//Finally return the texture by doing a texture lookup
				return tex2D(_MainTex, processedUV);
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
