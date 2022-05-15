using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClaxShow : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

    }
    public GameObject[] Effects;

    public Material[] matSh;

    int add = 0;
    GameObject eff;
    public void NextEff()
    {

        try { Destroy(eff); 
        eff = Instantiate(Effects[add], transform.position, Quaternion.identity);
        eff.transform.GetChild(0).GetComponent<MeshRenderer>().material = matSh[mattInt];
        eff.transform.SetParent(this.transform, true); eff.transform.localScale = Vector3.one * 2;
       
        }   catch { }
        add += 1;
    }
    int mattInt;

    int Timm = 0;

    private void Update()
    {
        transform.RotateAround(transform.position, Vector3.up, 30 * Time.deltaTime);

        if (Input.GetKeyDown(KeyCode.Z))
        {
            NextEff();
        }
 

            if (Input.GetKeyDown(KeyCode.X))
            {
                mattInt += 1;
                eff.transform.GetChild(0).GetComponent<MeshRenderer>().material = matSh[mattInt];

                if (mattInt > matSh.Length - 2) mattInt = 0;
            }
            if (Input.GetKeyDown(KeyCode.C))
            {
                mattInt -= 1;
                eff.transform.GetChild(0).GetComponent<MeshRenderer>().material = matSh[mattInt];

                if (mattInt < 0) mattInt = 0;
            }

     
        Timm += 1;
        if (Timm > 350)
        { NextEff(); Timm = 0; }
    }
}
