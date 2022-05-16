// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/Community/TOPFlatProjection 1"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Normal("Normal", 2D) = "bump" {}
		_DisolveGuide1("Disolve Guide1", 2D) = "white" {}
		_DisolveGuide2("Disolve Guide2", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( -5 , 5)) = 0
		_Displace("Displace", Range( -0.5 , 0.5)) = 0
		_SizeLines("SizeLines", Float) = 999
		_ColorMain("ColorMain", Color) = (0.2520217,1,0.1273585,0)
		_AnimDivB("AnimDivB", Range( -1 , 10)) = 0.15
		_AnimDivC("AnimDivC", Range( -1 , 10)) = 0.15
		_MeshDrag("MeshDrag", Vector) = (0,0,0,0)
		_HueScaleCol("HueScaleCol", Float) = 2
		_ZhadBlesk("ZhadBlesk", Float) = 3
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZTest LEqual
		Blend SrcAlpha One
		BlendOp Add
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _DissolveAmount;
		uniform float _Displace;
		uniform float3 _MeshDrag;
		uniform sampler2D _Normal;
		uniform float _SizeLines;
		uniform float _AnimDivB;
		uniform float4 _ColorMain;
		uniform sampler2D _DisolveGuide1;
		uniform sampler2D _DisolveGuide2;
		uniform float _AnimDivC;
		uniform float _HueScaleCol;
		uniform float _ZhadBlesk;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( ( ase_worldNormal * _DissolveAmount * _Displace ) + _MeshDrag );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos172 = UnityObjectToClipPos( ase_vertex4Pos.xyz );
			float4 computeScreenPos171 = ComputeScreenPos( unityObjectToClipPos172 );
			float temp_output_173_0 = (ase_vertex4Pos).w;
			float4 temp_output_184_0 = ( ( computeScreenPos171 / temp_output_173_0 ) * _SizeLines );
			float4 temp_output_182_0 = ( temp_output_184_0 + 99.0 + ( _SinTime.x * _AnimDivB ) );
			o.Normal = UnpackNormal( tex2D( _Normal, temp_output_182_0.xy ) );
			float4 tex2DNode2 = tex2D( _DisolveGuide1, temp_output_182_0.xy );
			float4 tex2DNode156 = tex2D( _DisolveGuide2, ( temp_output_184_0 + 99.0 + ( ( _CosTime.x * _AnimDivC ) * _SizeLines ) ).xy );
			float4 temp_output_212_0 = ( ( tex2DNode2 * tex2DNode156 ) * _HueScaleCol );
			float4 temp_output_207_0 = ( _ColorMain * temp_output_212_0 );
			o.Emission = temp_output_207_0.rgb;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3 clampResult205 = clamp( ( ase_vertexNormal * ase_worldNormal * _ZhadBlesk ) , float3( 0,0,0 ) , float3( 200,200,200 ) );
			float3 clampResult210 = clamp( ( _DissolveAmount + clampResult205 ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			o.Alpha = clampResult210.x;
			clip( temp_output_207_0.r - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
413;464;1571;915;242.7418;153.2678;1;True;True
Node;AmplifyShaderEditor.PosVertexDataNode;170;-2046.056,664.9464;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;172;-1738.927,618.3867;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;193;-1447.652,1370.318;Inherit;False;Property;_AnimDivC;AnimDivC;14;0;Create;True;0;0;0;False;0;False;0.15;1.17;-1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;171;-1487.365,655.43;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;173;-1449.658,820.3851;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;192;-1448.042,1208.727;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;186;-1197.249,903.9229;Inherit;False;Property;_SizeLines;SizeLines;11;0;Create;True;0;0;0;False;0;False;999;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;177;-1460.639,936.4493;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;128;-967.3727,510.0833;Inherit;False;908.2314;498.3652;Dissolve - Opacity Mask;8;4;71;2;73;111;182;181;201;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-1229.868,1229.69;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;174;-1203.39,773.2914;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-1560.229,1118.253;Inherit;False;Property;_AnimDivB;AnimDivB;13;0;Create;True;0;0;0;False;0;False;0.15;10;-1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;195;-849.105,1017.605;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-1275.445,1004.625;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-1017.249,1137.823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-854.682,940.54;Inherit;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-1072.249,756.8229;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalVertexDataNode;201;-282.401,822.3829;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-878.4641,807.9075;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;-803.0273,1104.198;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;214;293.1766,1014.268;Inherit;False;Property;_ZhadBlesk;ZhadBlesk;18;0;Create;True;0;0;0;False;0;False;3;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;202;-273.8267,993.301;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-123.1455,695.4993;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;156;-681.4724,1057.153;Inherit;True;Property;_DisolveGuide2;Disolve Guide2;5;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;ec7b133d6ec942540833b8ccf3be2ae7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-643.3626,768.1237;Inherit;True;Property;_DisolveGuide1;Disolve Guide1;4;0;Create;True;0;0;0;False;0;False;-1;0bbd24355cfb3074392f4e25176bc9da;c8025b74576a92644ad39b09ddac8490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;160;-57.08832,1141.994;Float;False;Property;_Displace;Displace;8;0;Create;True;0;0;0;False;0;False;0;0.01;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-36.70234,578.894;Inherit;False;Property;_HueScaleCol;HueScaleCol;17;0;Create;True;0;0;0;False;0;False;2;99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-405.4524,971.4606;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;205;49.68409,705.1572;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;200,200,200;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-966.0623,577.7472;Float;False;Property;_DissolveAmount;Dissolve Amount;7;0;Create;True;0;0;0;False;0;False;0;-0.35;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;144.1929,26.72195;Inherit;False;765.1592;493.9802;Created by The Four Headed Cat @fourheadedcat - www.twitter.com/fourheadedcat;7;0;206;207;210;211;218;224;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;159;-79.11678,852.1024;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;129;-892.9326,49.09825;Inherit;False;814.5701;432.0292;Burn Effect - Emission;6;113;126;115;114;112;130;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;199;389.421,791.0723;Inherit;False;Property;_MeshDrag;MeshDrag;16;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;324.0332,649.606;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-82.16719,388.8819;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;162;-87.71903,-122.08;Inherit;False;Property;_ColorMain;ColorMain;12;0;Create;True;0;0;0;False;0;False;0.2520217,1,0.1273585,0;0.05873977,0.07353467,0.2264151,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;206;218.4238,420.7052;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;211;143.3948,264.0626;Inherit;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;COLOR;0,0,0,0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;177.7661,129.2167;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;112;-878.1525,280.8961;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;67.56104,420.6198;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;135;-990.4471,-203.321;Inherit;True;Property;_EmissA;EmissA;2;0;Create;True;0;0;0;False;0;False;-1;None;94cd628d3d8e07d40a85d82b3fdad15d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;113;-797.634,90.31517;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;115;-610.9893,313.0966;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;197;526.421,610.0723;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-48.62109,1023.586;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;141;-1451.691,-398.313;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;191;-158.0035,200.7781;Inherit;False;Property;_ColorEmiss;ColorEmiss;15;0;Create;True;0;0;0;False;0;False;0,0.3679245,0.2178739,0;0,0.3679245,0.2178739,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-353.1819,1164.411;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-448.9384,290.8904;Inherit;True;Property;_BurnRamp;Burn Ramp;6;0;Create;True;0;0;0;False;0;False;-1;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;138;271.3606,-451.3076;Inherit;False;Property;_MullCol;MullCol;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-202.3633,125.7657;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;131;-313.0316,-299.3296;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;07944ba93895c3d43869c3b14beb60b4;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-1216.811,637.8036;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;217;141.6914,558.8287;Inherit;False;Property;_HueScaleColB;HueScaleColB;19;0;Create;True;0;0;0;False;0;False;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-543.2424,1288.151;Inherit;False;Constant;_Float0;Float 0;18;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;-655.2471,583.1434;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;224;544.8521,364.9182;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;223;352.4373,548.051;Inherit;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;0;False;0;False;-0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;210;384.2402,310.7568;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;258.9446,-43.29352;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-319.6845,566.4299;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;111;-521.4305,581.9279;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;140;-1824.915,-336.7525;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;-195.8022,-593.1658;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;0bbd24355cfb3074392f4e25176bc9da;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;167;-2040.709,425.8882;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;130;-627.5982,83.10277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;10.79348,84.1115;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;-1255.779,-427.0171;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;144;-1927.041,-261.3391;Inherit;False;Property;_AnimDivA;AnimDivA;9;0;Create;True;0;0;0;False;0;False;0.04;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-1621.041,-314.3391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;702.637,92.61272;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/Community/TOPFlatProjection 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;172;0;170;0
WireConnection;171;0;172;0
WireConnection;173;0;170;0
WireConnection;194;0;192;1
WireConnection;194;1;193;0
WireConnection;174;0;171;0
WireConnection;174;1;173;0
WireConnection;187;0;177;1
WireConnection;187;1;188;0
WireConnection;185;0;194;0
WireConnection;185;1;186;0
WireConnection;184;0;174;0
WireConnection;184;1;186;0
WireConnection;182;0;184;0
WireConnection;182;1;181;0
WireConnection;182;2;187;0
WireConnection;196;0;184;0
WireConnection;196;1;195;0
WireConnection;196;2;185;0
WireConnection;204;0;201;0
WireConnection;204;1;202;0
WireConnection;204;2;214;0
WireConnection;156;1;196;0
WireConnection;2;1;182;0
WireConnection;208;0;2;0
WireConnection;208;1;156;0
WireConnection;205;0;204;0
WireConnection;157;0;159;0
WireConnection;157;1;4;0
WireConnection;157;2;160;0
WireConnection;212;0;208;0
WireConnection;212;1;213;0
WireConnection;206;0;4;0
WireConnection;206;1;205;0
WireConnection;211;1;218;0
WireConnection;207;0;162;0
WireConnection;207;1;212;0
WireConnection;112;0;73;0
WireConnection;218;0;212;0
WireConnection;218;1;217;0
WireConnection;135;1;155;0
WireConnection;113;0;112;0
WireConnection;115;0;130;0
WireConnection;197;0;157;0
WireConnection;197;1;199;0
WireConnection;141;0;146;0
WireConnection;141;1;146;0
WireConnection;209;0;2;1
WireConnection;209;1;156;1
WireConnection;209;2;215;0
WireConnection;114;1;115;0
WireConnection;126;0;130;0
WireConnection;126;1;114;0
WireConnection;131;1;182;0
WireConnection;200;0;171;0
WireConnection;200;1;173;0
WireConnection;71;0;4;0
WireConnection;224;0;210;0
WireConnection;224;1;223;0
WireConnection;210;0;206;0
WireConnection;220;0;207;0
WireConnection;220;1;210;0
WireConnection;73;0;111;0
WireConnection;73;1;209;0
WireConnection;111;0;71;0
WireConnection;78;1;155;0
WireConnection;130;0;113;0
WireConnection;137;0;126;0
WireConnection;137;1;135;0
WireConnection;137;2;138;0
WireConnection;155;1;141;0
WireConnection;146;0;140;0
WireConnection;146;1;144;0
WireConnection;0;1;131;0
WireConnection;0;2;207;0
WireConnection;0;9;210;0
WireConnection;0;10;207;0
WireConnection;0;11;197;0
ASEEND*/
//CHKSM=324CCEDCAA7F6B8D18AB9867CC300D2D92E24311