using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterControl : MonoBehaviour {

    public float lerpSpeed = 5f;
    public float dampingSpeed = 0.3f;
    private float lerpValue;
    private float maxAngle_diff = -1f;
    private Quaternion maxQuat_diff = Quaternion.identity;

    private void Update()
    {
        Quaternion currentRot = transform.rotation;
        Quaternion diff = currentRot * Quaternion.Inverse(Quaternion.identity);
        float angle_diff = Quaternion.Angle(currentRot, Quaternion.identity);
        if (angle_diff > maxAngle_diff)
        {
            maxAngle_diff = angle_diff;
            maxQuat_diff = diff;
        }

        maxQuat_diff = Quaternion.Slerp(maxQuat_diff, Quaternion.identity, dampingSpeed * Time.deltaTime);
        transform.rotation = Quaternion.SlerpUnclamped(transform.rotation, Quaternion.Inverse(maxQuat_diff), lerpSpeed * Time.deltaTime);

        //print("CurrentRot " + currentRot + " diff * id " + diff * Quaternion.identity + " diff " + diff + " diff inverse " + Quaternion.Inverse(diff));
    }
}
