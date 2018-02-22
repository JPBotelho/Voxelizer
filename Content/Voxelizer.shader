Shader "Voxelizer"  
{	
	Properties 
	{
		_Color ("Color", Color) = (1, 1, 1, 1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0, 1)) = 0.5
		_Metallic("Metallic", Range(0, 1)) = 0.0

		_Voxelizer("Voxelizer", Range(0.5, 4) ) = 1
	}
	SubShader
	{
		Tags 
		{ 
			"RenderType"="Opaque" 
			"DisableBatching" = "True"
		}

		LOD 200
		
		CGPROGRAM
		
		#pragma surface surf Standard fullforwardshadows vertex:vert addshadow
		#pragma target 3.0
		
		#include "UnityCg.cginc"
		
		struct Input 
		{
			float2 uv_MainTex;
			float4 color : Color;
		};

		//Standard Surface Shader Properties
		sampler2D _MainTex;
		fixed4 _Color;
		half _Glossiness;
		half _Metallic;

		float _Voxelizer;
		
		void vert( inout appdata_full v )
		{
			v.vertex = mul(unity_ObjectToWorld, v.vertex);		
			v.vertex = (round(v.vertex * _Voxelizer)) / _Voxelizer;
			v.vertex = mul(unity_WorldToObject, v.vertex);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{			
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			o.Albedo = c;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;			
		}
		ENDCG
	}
	FallBack "Diffuse"
}
