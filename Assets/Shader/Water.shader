Shader "Unlit/Water"
{
    Properties
    {
        _NoiseTex("Noise Tex", 2D) = "white" {}
        _NoiseScale("Noise Scale",Range(0,3)) = 1
        _BaseColor("BaseColor",Color) = (1,1,1,1)
        _FoamTexture("Foam Tex", 2D) = "white" {}
        _FoamColor("FormColor",Color) = (1,1,1,1)
        _FoamDistance("Foam Distance", Float) = 1
        _FoamTexScale("Foam Tex Scale", Range(0.1, 10)) = 1
        _FoamFadeStrength("Foam Fade Strength", Range(1, 40)) = 20
        _Stencil("Stencil", int) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            Tags {"LightMode" = "ForwardBase" "Queue" = "Transparent"}
            Stencil{
                ref [_Stencil]
                comp equal
                pass replace
            }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float3 objPos : TEXCOORD3;
                float4 vertex : SV_POSITION;
            };

            sampler2D _NoiseTex;
            sampler2D _FoamTexture;
            float4 _NoiseTex_ST;
            fixed4 _BaseColor;
            fixed4 _FoamColor;
            half _FoamDistance;
            half _NoiseScale;
            half _FoamTexScale;
            half _FoamFadeStrength;
            float4 _objPos;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.objPos = unity_ObjectToWorld._m00_m01_m02;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 N = normalize(i.worldNormal);
                float dis = length(_objPos - i.worldPos);
                fixed noise = tex2D(_NoiseTex, i.uv + _Time.x / 10).r;
                fixed4 foam = tex2D(_FoamTexture, i.worldPos.xz * _FoamTexScale);
                half factor = (dis + (noise - 0.5) * _NoiseScale) / _FoamDistance;
                fixed4 col = lerp(_BaseColor, _FoamColor * foam, saturate((factor - 0.5) * _FoamFadeStrength - 0.5));
                return col;
            }
            ENDCG
        }
    }
}
