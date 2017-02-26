using UnityEngine;
using System.Collections;
//Author: Jack Kheir
//Course: Games Development BSC
//Module: C0569 GPU Programming and Shaders 
//Assignment: CW1
public class DissolveOverTime : MonoBehaviour {

	//Define a material to hold the cube material to manipulate the shader values
	public Material dissolveMaterial;
	private float dissolveAmount = 1.2f;

	// Use this for initialization
	void Start () {
		//start coroutine
		StartCoroutine(Dissolve());
	}

	IEnumerator Dissolve() {
		//Assign dissolveValue within the shader the dissolve amount
		dissolveMaterial.SetFloat("_DissolveValue", dissolveAmount);
		//wait half a sec
		yield return new WaitForSeconds(0.5f);
		//check to see if dissolve amount is greater than 0
		if(dissolveAmount >= 0.0f){
			//decrement the amount
			dissolveAmount -= 0.1f;
			//Call the coroutine again
			StartCoroutine(Dissolve());
		}
	}

}
