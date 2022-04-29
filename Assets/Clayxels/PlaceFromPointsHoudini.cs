using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.IO;
using System.Collections.Generic;
using System;
using Clayxels;
public class PlaceFromPointsHoudini : MonoBehaviour
{
    public TextAsset csvFile; // Reference of CSV file
    public GameObject PrefabSvetofor;
    //public InputField nameInputField; // Reference of name input filed
    //public Text contentArea; // Reference of contentArea where records are displayed

    private char lineSeperater = '\n'; // It defines line seperate character
    private char fieldSeperator = '\"'; // It defines field seperate chracter


    GameObject[] blobs;
    public List<CameraShakePreset> list = new List<CameraShakePreset>();
    void Start()
    {
        readData();
        blobs = new GameObject[list.Count];
        for (int i = 1; i < list.Count; ++i)
        {
            GameObject inst = Instantiate(PrefabSvetofor, new Vector3(list[i].pos.x + transform.position.x, list[i].pos.y + transform.position.y, list[i].pos.z + transform.position.z), list[i].rot);
            inst.transform.localScale = list[i].scal;
            //inst.GetComponent<MeshRenderer>().material.SetColor("_Color", list[i].col);
            inst.GetComponent<ClayObject>().color = list[i].col;
            blobs[i] = inst; list[i].blob = blobs[i];
            inst.transform.SetParent(transform, true);
            inst.SetActive(true);
        }
    }
    // Read data from CSV file
    string[] fields;
    private void readData()
    {
        int i = 0, ii = 0; string[] FirstPole = new string[] { "" };
        string[] records = csvFile.text.Split(lineSeperater);
        RemoveAt(ref records, records.Length - 1); // removes последний элемент.
        foreach (string record in records)
        {
            i += 1;
            string RecordPrepare = record.Replace("\",", "^");
            RecordPrepare = RecordPrepare.Replace(",\"", "^");
            string[] fields = RecordPrepare.Split('^');
            Debug.Log("F_" + RecordPrepare);
            CameraShakePreset cameraShakePreset = new CameraShakePreset();
            list.Add(cameraShakePreset);
            foreach (string field in fields)
            {

                if (i == 1)
                { FirstPole = ("," + RecordPrepare).Split(','); }
                ii += 1;

                string fieldCoords = field.Replace(",", " "); fieldCoords = fieldCoords.Replace("\"", "");
                fieldCoords = fieldCoords.Replace("(", ""); fieldCoords = fieldCoords.Replace(")", "");
                fieldCoords = fieldCoords.Replace(".", ",");
                Debug.Log("i_" + i + "_II_" + ii + FirstPole[ii] + "| " + fieldCoords + "\t");
                // ������ ���� ���������� �� ��������� � ������ ������� ������ �� ������
                if (FirstPole[ii] == "P" && i > 1) // P
                {
                    float px = 0, py = 0, pz = 0;
                    float.TryParse(fieldCoords.Split(' ')[0], out px);
                    float.TryParse(fieldCoords.Split(' ')[2], out py);
                    float.TryParse(fieldCoords.Split(' ')[4], out pz);

                    list[i - 1].pos = new Vector3(px, py, pz);
                }
                if (FirstPole[ii] == "scale" && i > 1) // P
                {
                    float sx = 0, sy = 0, sz = 0;
                    float.TryParse(fieldCoords.Split(' ')[0], out sx);
                    float.TryParse(fieldCoords.Split(' ')[2], out sy);
                    float.TryParse(fieldCoords.Split(' ')[4], out sz);
                   // list[i - 1].scal = new Vector3(sx, sy, sz);
                }
                if (FirstPole[ii] == "N" && i > 1) // N 
                {
                    float Nx = 0, Ny = 0, Nz = 0;
                    float.TryParse(fieldCoords.Split(' ')[0], out Nx);
                    float.TryParse(fieldCoords.Split(' ')[2], out Ny);
                    float.TryParse(fieldCoords.Split(' ')[4], out Nz);

                    list[i - 1].N = new Vector3(Nx, Ny, Nz);
                }

                if (FirstPole[ii] == "orient" && i > 1) // orient
                {
                    float Qx = 0, Qy = 0, Qz = 0, Qw = 0;
                    float.TryParse(fieldCoords.Split(' ')[0], out Qx);
                    float.TryParse(fieldCoords.Split(' ')[2], out Qy);
                    float.TryParse(fieldCoords.Split(' ')[4], out Qz);
                    float.TryParse(fieldCoords.Split(' ')[6], out Qw);
                    list[i - 1].rot = new Quaternion(Qx, Qy, Qz, Qw);
                }

                if (FirstPole[ii] == "Cd" && i > 1) // N 
                {
                    float Cx = 0, Cy = 0, Cz = 0;
                    float.TryParse(fieldCoords.Split(' ')[0], out Cx);
                    float.TryParse(fieldCoords.Split(' ')[2], out Cy);
                    float.TryParse(fieldCoords.Split(' ')[4], out Cz);

                    list[i - 1].col = new Color(Cx, Cy, Cz, 0);
                }

                if (FirstPole[ii] == "pscale" && i > 1) // N 
                {
                    float pscale = 0;
                    float.TryParse(fieldCoords.Split(' ')[0], out pscale);
                    list[i - 1].scal = new Vector3(pscale, pscale, pscale);
                }
                if (FirstPole[ii] == "posarray" && i > 1) // анимацию в массив циклом
                {


                    fields = fieldCoords.Split(' ');
                    list[i - 1].StrMAnim = new string[fields.Length];
                    list[i - 1].posesAnim = new Vector3[(fields.Length + 1) / 6];
                    for (int f = 0; f < fields.Length; ++f)
                    {
                        list[i - 1].StrMAnim[f] = fields[f];
                    }
                    for (int g = 0; g < list[i - 1].posesAnim.Length; ++g)
                    {


                        float valX; string strX = fields[g * 6];
                        float.TryParse(strX, out valX);

                        float valY; string strY = fields[g * 6 + 2];
                        float.TryParse(strY, out valY);

                        float valZ; string strZ = fields[g * 6 + 4];
                        float.TryParse(strZ, out valZ);

                        list[i - 1].posesAnim[g] = new Vector3(valX/1000, valY/1000, valZ/1000);
                    }
                    list[i - 1].StrMAnim = new string[0];
                }
            }
            ii = 0;
            // contentArea.text += '\n';
        }
    }
    // Add data to CSV file
    public void addData()
    {
#if UNITY_EDITOR
        UnityEditor.AssetDatabase.Refresh();
#endif
        readData();
    }
    public float AnimSpeed = 15;  float time;
    void Update()
    {
        time = time + Time.deltaTime* AnimSpeed; if (time > list[1].posesAnim.Length) time = 0;
        for (int i = 1; i < list.Count; ++i)
        {
            list[i].blob.transform.localPosition = list[i].posesAnim[(int)time];
            //StartCoroutine(SmoothLerp(0.2f, list[i].posesAnim[(int)time], i));
        }
        
    }
    private IEnumerator SmoothLerp(float time, Vector3 finalPos,int i) // сглаживаем позицию эффекта
    {
        Vector3 startingPos = list[i].blob.transform.localPosition;
        //Vector3 finalPos = transform.GetChild(0).position + (transform.GetChild(0).forward * 5);
        float elapsedTime = 0;

        while (elapsedTime < time)
        {
            list[i].blob.transform.localPosition = Vector3.Lerp(startingPos, finalPos, (elapsedTime / time));
            elapsedTime += Time.deltaTime;
            yield return null;
        }
    }
    // Get path for given CSV file
    private static string getPath()
    {
#if UNITY_EDITOR
        return Application.dataPath;
#elif UNITY_ANDROID
return Application.persistentDataPath;// +fileName;
#elif UNITY_IPHONE
return GetiPhoneDocumentsPath();// +"/"+fileName;
#else
return Application.dataPath;// +"/"+ fileName;
#endif
    }
    // Get the path in iOS device
    private static string GetiPhoneDocumentsPath()
    {
        string path = Application.dataPath.Substring(0, Application.dataPath.Length - 5);
        path = path.Substring(0, path.LastIndexOf('/'));
        return path + "/Documents";
    }
    public static void RemoveAt<T>(ref T[] arr, int index)
    {
        for (int a = index; a < arr.Length - 1; a++)
        {
            // moving elements downwards, to fill the gap at [index]
            arr[a] = arr[a + 1];
        }
        // finally, let's decrement Array's size by one
        Array.Resize(ref arr, arr.Length - 1);
    }
}
[Serializable]
public class CameraShakePreset
{
    /* [Serializable] // ������ � �������������
     public struct Shake
     {
         public float Frequency;
         public float Amplitude;
     }

     public Shake[] RotationalX;
     public Shake[] RotationalY;
     public Shake[] RotationalZ;*/

    public GameObject blob;
    public Vector3 pos;

    public String[] StrMAnim;

    public Vector3[] posesAnim;
    //public Vector3[] rotersAnim;
    public Color col;
    public Quaternion rot;
    public Vector3 scal;
    public Vector3 N;
}