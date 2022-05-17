using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateGalaxy : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }
    public bool X, Y, Z;
    public float speed = -30;
    // Update is called once per frame
    void Update()
    {
        Vector3 rot = Vector3.down;
        if (X) rot = Vector3.up;
        if (Y) rot = Vector3.right;
        if (Z) rot = Vector3.forward*-1;

        transform.RotateAround(transform.position, rot, speed * Time.deltaTime);
    }
}
