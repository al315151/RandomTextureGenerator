using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;


public class ExportTextures : MonoBehaviour {

    public Material testMaterial;

    string pathToExport;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update ()
    {
	    if (Input.GetKeyDown(KeyCode.P))
        {
            StartCoroutine("StartExport");
        }
        
	}

    IEnumerator StartExport()
    {
        yield return SetAndSavePNG();
    }

    IEnumerator SetAndSavePNG()
    {
        yield return new WaitForEndOfFrame();

        int width = Screen.width;
        int height = Screen.height;
        Texture2D tex = new Texture2D(width, height, TextureFormat.RGB24, false);

        tex.ReadPixels(new Rect(0, 0, width, height), 0, 0);
        tex.Apply();

        byte[] bytes = tex.EncodeToPNG();
        Object.Destroy(tex);

        File.WriteAllBytes(Application.dataPath + "/SavedScreen.png", bytes);
        print(Application.dataPath + "/SavedScreen.png");

    }


}
