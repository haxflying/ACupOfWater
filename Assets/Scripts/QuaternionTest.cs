using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuaternionTest : MonoBehaviour {

    [Range(0f, 1f)]
    public float lerpValue;

    public Vector3 target;
    public Quaternion rot, diff;

    private void Start()
    {
        rot = transform.rotation;
        diff = transform.rotation * Quaternion.Inverse(Quaternion.identity);
    }

    private void Update()
    {

        transform.rotation = Quaternion.Slerp(rot, Quaternion.Inverse(diff), lerpValue);
    }
}
