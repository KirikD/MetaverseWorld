using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Container : MonoBehaviour {
    public float safeZone;
    public float resolution;
    public float threshold;
    public ComputeShader computeShader;
    public bool calculateNormals;

    private CubeGrid grid;

    public void Start() {
        this.grid = new CubeGrid(this, this.computeShader);
    }

    public void Update() {
        this.grid.evaluateAll(this.GetComponentsInChildren<MetaBall>());

        Mesh mesh = this.GetComponent<MeshFilter>().mesh;
        mesh.Clear();
        mesh.vertices = this.grid.vertices.ToArray();
        mesh.triangles = this.grid.getTriangles();
        mesh.colors = this.grid.colors.ToArray(); ;


        // create new colors array where the colors will be created.


        // for (int i = 0; i < mesh.vertices.Length; i++)
        //   colors[i] = Color.green;

        // assign the array of colors to the Mesh.


        if (this.calculateNormals) {
            mesh.RecalculateNormals();
        }
    }
}

/*
  Mesh mesh = GetComponent<MeshFilter>().mesh;
        Vector3[] mesh = mesh.vertices;

        // create new colors array where the colors will be created.
        Color[] colors = new Color[mesh.Length];

        for (int i = 0; i < mesh.Length; i++)
            colors[i] = Color.Lerp(Color.red, Color.green, mesh[i].y);

        // assign the array of colors to the Mesh.
        mesh.colors = colors;
 */