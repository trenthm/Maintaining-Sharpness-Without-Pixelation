using UnityEngine;
using System;

public class ScreenshotController : MonoBehaviour
{
    void LateUpdate()
    {
        if (Input.GetKeyDown("1"))
        {
            Debug.Log("Screenshots/" + DateTime.Now.ToString("MM-dd-yyyy HH.mm.ss") + ".png");
            ScreenCapture.CaptureScreenshot("Screenshots/" + DateTime.Now.ToString("MM-dd-yyyy HH.mm.ss") + ".png");
        }
    }
}