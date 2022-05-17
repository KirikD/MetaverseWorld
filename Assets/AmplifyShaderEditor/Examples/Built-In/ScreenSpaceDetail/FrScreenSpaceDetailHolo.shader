// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/FrScreenSpaceDetailHolo"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_CheckersA("CheckersA", 2D) = "white" {}
		_CheckersB("CheckersB", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_DisplScal("DisplScal", Float) = 0.1
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_Emis("Emis", Color) = (0,0,0,0)
		_AnimDivB1("AnimDivB", Range( -1 , 1)) = 0.15
		_AnimDivC1("AnimDivC", Range( -1 , 1)) = 0.15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _CheckersA;
		uniform float _AnimDivB1;
		uniform sampler2D _CheckersB;
		uniform float _AnimDivC1;
		uniform float _DisplScal;
		uniform float4 _Emis;
		uniform float _DissolveAmount;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_Albedo = v.texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 ase_vertex4Pos = v.vertex;
			float4 unityObjectToClipPos47 = UnityObjectToClipPos( ase_vertex4Pos.xyz );
			float4 computeScreenPos48 = ComputeScreenPos( unityObjectToClipPos47 );
			float4 temp_output_57_0 = ( ( computeScreenPos48 / (computeScreenPos48).z ) * 1.0 );
			float4 temp_output_8_0 = ( tex2Dlod( _Albedo, float4( uv_Albedo, 0, 0.0) ) * tex2Dlod( _CheckersA, float4( ( temp_output_57_0 + 99.0 + ( _SinTime.x * _AnimDivB1 ) ).xy, 0, 0.0) ) * tex2Dlod( _CheckersB, float4( ( temp_output_57_0 + 99.0 + ( _CosTime.x * _AnimDivC1 ) ).xy, 0, 0.0) ) );
			v.vertex.xyz += ( float4( ase_vertexNormal , 0.0 ) * temp_output_8_0 * _DisplScal ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos47 = UnityObjectToClipPos( ase_vertex4Pos.xyz );
			float4 computeScreenPos48 = ComputeScreenPos( unityObjectToClipPos47 );
			float4 temp_output_57_0 = ( ( computeScreenPos48 / (computeScreenPos48).z ) * 1.0 );
			float4 temp_output_8_0 = ( tex2D( _Albedo, uv_Albedo ) * tex2D( _CheckersA, ( temp_output_57_0 + 99.0 + ( _SinTime.x * _AnimDivB1 ) ).xy ) * tex2D( _CheckersB, ( temp_output_57_0 + 99.0 + ( _CosTime.x * _AnimDivC1 ) ).xy ) );
			o.Albedo = temp_output_8_0.rgb;
			o.Emission = ( _Emis * 2.0 ).rgb;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV43 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode43 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV43, 5.0 ) );
			float clampResult42 = clamp( ( fresnelNode43 * 290.0 ) , 0.0 , 1.0 );
			clip( ( ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + temp_output_8_0 ) * clampResult42 ).r - _Cutoff );
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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
25;500;1571;879;-89.76929;645.1288;1.018141;True;True
Node;AmplifyShaderEditor.PosVertexDataNode;46;-2234.406,1312.536;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;47;-1937.43,1297.297;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;48;-1739.33,1316.315;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;49;-1745.729,1471.298;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1736.424,2000.613;Inherit;False;Property;_AnimDivC1;AnimDivC;10;0;Create;True;0;0;0;False;0;False;0.15;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-1536.408,1414.968;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1712.001,1741.548;Inherit;False;Property;_AnimDivB1;AnimDivB;9;0;Create;True;0;0;0;False;0;False;0.15;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;50;-1710.411,1579.744;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;-1542.021,1521.118;Inherit;False;Constant;_Float3;Float 2;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;54;-1756.814,1855.022;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-1390.454,1689.835;Inherit;False;Constant;_Float5;Float 4;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1380.021,1422.118;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1538.64,1875.985;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-1390.877,1791.9;Inherit;False;Constant;_Float4;Float 3;10;0;Create;True;0;0;0;False;0;False;99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1517.217,1641.919;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-1187.237,1454.202;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-30.79242,570.3818;Float;False;Property;_DissolveAmount;Dissolve Amount;6;0;Create;True;0;0;0;False;0;False;0;0.31;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-1159.226,1756.072;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;44;775.3574,678.4898;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;290;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;43;764.3226,878.411;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;233.0029,571.2277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-781.3001,488.5042;Inherit;True;Property;_CheckersB;CheckersB;3;0;Create;True;0;0;0;False;0;False;-1;None;4d901885c71a57041a96c5e30b1ac116;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-792.0665,185.269;Inherit;True;Property;_CheckersA;CheckersA;2;0;Create;True;0;0;0;False;0;False;-1;None;0bbd24355cfb3074392f4e25176bc9da;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-537.3115,-80;Inherit;True;Property;_Albedo;Albedo;4;0;Create;True;0;0;0;False;0;False;-1;None;20b6f3caf6fca4a4fa04eab14006189d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-199,88;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;844.5854,586.1667;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;31;361.8195,572.0123;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;790.2502,-177.8019;Inherit;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-125.6428,419.3746;Inherit;False;Property;_DisplScal;DisplScal;5;0;Create;True;0;0;0;False;0;False;0.1;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;545.4501,426.4347;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;25;-150.855,251.2538;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;42;986.3838,624.3687;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;745.3242,-535.3971;Inherit;False;Property;_Emis;Emis;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.7597713,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1178.528,-222.5283;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;-1514.311,-546.931;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;4;-2171.971,134.2722;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;39;-2024.115,-732.8941;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-1201.515,-357.3901;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-983.0964,545.84;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;36;-2332.731,-650.6578;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;40;-1760.795,-503.9795;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1282.487,733.1984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;1069.672,447.4693;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1157.489,363.6986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;12;-1628.973,800.5172;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1626.696,655.358;Inherit;False;Property;_MinScale;MinScale;8;0;Create;True;0;0;0;False;0;False;0.23;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-1698.483,475.5133;Float;False;Property;_Scal;Scal;1;0;Create;True;0;0;0;False;0;False;8,6;4,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;546.28,541.7559;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinTimeNode;11;-1488.141,331.9486;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;6;-1915.971,134.2722;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1012.891,161.2325;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;37;-1774.04,-660.1742;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;999.9877,-212.4188;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1273.262,7.449174;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/FrScreenSpaceDetailHolo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;46;0
WireConnection;48;0;47;0
WireConnection;49;0;48;0
WireConnection;51;0;48;0
WireConnection;51;1;49;0
WireConnection;57;0;51;0
WireConnection;57;1;52;0
WireConnection;60;0;54;1
WireConnection;60;1;55;0
WireConnection;56;0;50;1
WireConnection;56;1;53;0
WireConnection;61;0;57;0
WireConnection;61;1;59;0
WireConnection;61;2;56;0
WireConnection;63;0;57;0
WireConnection;63;1;58;0
WireConnection;63;2;60;0
WireConnection;30;0;29;0
WireConnection;21;1;63;0
WireConnection;2;1;61;0
WireConnection;8;0;1;0
WireConnection;8;1;2;0
WireConnection;8;2;21;0
WireConnection;41;0;43;0
WireConnection;41;1;44;0
WireConnection;31;0;30;0
WireConnection;32;0;31;0
WireConnection;32;1;8;0
WireConnection;42;0;41;0
WireConnection;65;1;34;0
WireConnection;38;0;37;0
WireConnection;38;1;40;0
WireConnection;39;0;36;0
WireConnection;64;1;13;0
WireConnection;18;0;6;0
WireConnection;18;1;10;0
WireConnection;18;2;34;0
WireConnection;40;0;36;0
WireConnection;34;0;12;1
WireConnection;34;1;35;0
WireConnection;45;0;32;0
WireConnection;45;1;42;0
WireConnection;13;0;11;1
WireConnection;13;1;35;0
WireConnection;26;0;25;0
WireConnection;26;1;8;0
WireConnection;26;2;28;0
WireConnection;6;0;4;0
WireConnection;9;0;6;0
WireConnection;9;1;10;0
WireConnection;9;2;13;0
WireConnection;37;0;39;0
WireConnection;66;0;33;0
WireConnection;66;1;67;0
WireConnection;0;0;8;0
WireConnection;0;2;66;0
WireConnection;0;10;45;0
WireConnection;0;11;26;0
ASEEND*/
//CHKSM=69E6A6A1F1FBD76BE6E1A155D7FF78CBD7B27B5F