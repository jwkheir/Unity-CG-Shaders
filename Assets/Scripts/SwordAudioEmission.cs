using UnityEngine;
using System.Collections;

public class SwordAudioEmission : MonoBehaviour {
	//Define audioSource to hold the audio that i'll take samples off of
	public AudioSource audioSource;
	//Define a material to hold the cube(s) material to manipulate the shader values
	public Material emissionMaterial;
	//Define a float array to contain the audio clip samples
	private float[] samples;

	void Awake()
	{
		//make an array to contain all the samples of the clip currently playing
		samples = new float[audio.clip.samples * audio.clip.channels];
		
		//store all the sample data of the clip in this array.
		audio.clip.GetData(samples, 0);
	}

	void Update() 
	{
		//find and assign the current sample to pass to the shader 
		float currentSample = samples[audio.timeSamples];
		emissionMaterial.SetFloat("_EmitPower", currentSample);
	}

}
