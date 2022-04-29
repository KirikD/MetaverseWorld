using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlobVertexUpddate : MonoBehaviour
{
    Vector3[] vertices; Vector3[] normals; Color[] colors;

    public GameObject metabollPrefab; Mesh mesh; SkinnedMeshRenderer skin;
    public GameObject[] metabols;
    void Start()
    {
        skin = GetComponent<SkinnedMeshRenderer>();
        Mesh baked = new Mesh();
        skin.BakeMesh(baked);
       vertices = baked.vertices;
         normals = baked.normals;
       colors = baked.colors;
        metabols = new GameObject[baked.vertices.Length];
        for (var i = 0; i < vertices.Length; i++)
        {
           
            metabols[i] = Instantiate(metabollPrefab, vertices[i], Quaternion.identity);
        
        
        }

        mesh.vertices = vertices;
    }


    // Update is called once per frame
    void Update()
    {
        skin = GetComponent<SkinnedMeshRenderer>();
        Mesh baked = new Mesh();
        skin.BakeMesh(baked);
        for (var i = 0; i < vertices.Length; i++)
        {
            metabols[i].transform.localPosition = vertices[i];


        }
    }
}
