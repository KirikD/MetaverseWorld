using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectsShower : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }
    public GameObject[] Effects;
    int add = 0;
    GameObject eff;
   public void NextEff()
    {
        try { Destroy(eff); } catch { }
        eff =  Instantiate(Effects[add], transform.position, Quaternion.identity);
        add += 1;
    }
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            NextEff();
        }
     }
}
