using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SetProp : MonoBehaviour
{
    private MaterialPropertyBlock prop;
    private Renderer render;

    private void OnEnable()
    {
        prop = new MaterialPropertyBlock();
        render = GetComponent<Renderer>();
    }

    void Update()
    {
        prop.SetVector("_objPos", transform.position);
        render.SetPropertyBlock(prop);
    }
}
