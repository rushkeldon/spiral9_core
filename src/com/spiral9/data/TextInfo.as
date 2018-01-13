/*******************************************************************************
 * (C) 2008 - 2012 SPIRAL9, INC. ( SPIRAL9 )
 * All Rights Reserved.
 *
 * NOTICE:  SPIRAL9 permits you to use, modify, and distribute this file in
 * accordance with the terms of the SPIRAL9 license agreement accompanying it.
 * If you have received this file without a license agreement or from a source
 * other than SPIRAL9 then your use, modification, or distribution of it requires
 * the prior written permission of SPIRAL9, INC.
 *******************************************************************************/
package com.spiral9.data
{

	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextInfo
	{
		private var CN : String = "TextInfo";
		
		public var text : String;
		public var htmlText : String;
		public var textField : TextField;
		public var textFormat : TextFormat;
		public var antiAliasType : String;
		public var autoSize : String;
		public var background : Boolean;
		public var backgroundColor : uint;
		public var border : Boolean;
		public var borderColor : uint;
		public var condenseWhite : Boolean;
		public var displayAsPassword : Boolean;
		public var embedFonts : Boolean;
		public var mouseWheelEnabled  : Boolean;
		public var multiline  : Boolean;
		public var restrict : String;
		public var selectable : Boolean;
		public var sharpness : Number;
		public var textColor : uint;
		public var type : String;
		public var wordWrap : Boolean;
		
		public function TextInfo()
		{
			trace( CN + ".TextInfo" );

		}

		/*
		TextFormat      StyleSheet      Note
		blockIndent     -               value to indent entire block instead of only first line
		-               display         Supported values are inline, block, none
		bold            fontWeight      TF: true|false; SS: normal:bold
		bullet          -               TF: part of bulleted list
		color           color           TF: AS notation (0xFFFFFF); SS: HTML (#FFFFFF)
		font            fontFamily      TF: 1 font; SS: uses comma separated list of fonts
		indent          textIndent
		italic          fontStyle       TF: true|false; SS: normal|italic
		kerning         kerning
		leading         leading
		leftMargin      marginLeft
		letterSpacing   letterSpacing
		rightMargin     marginRight
		size            fontSize
		tabStops        -               Size of tab
		target          -               target of link if url != null
		underline       textDecoration  TF : true|false; SS : none|underline
		url             -               Setting to non-null value makes text a clickable link
		*/
		/*
		For best appearance, use device fonts. For example, the following fonts are device fonts on the iPhone:
		Serif: Times New Roman, Georgia, and _serif
		Sans-serif: Helvetica, Arial, Verdana, Trebuchet, Tahoma, and _sans
		Fixed-width: Courier New, Courier, and _typewriter
		*/
		public static function iPhoneGetTextFormat( font : String = "Helvetica", size : uint = 30, color : uint = 0x000000 ) : TextFormat
		{
			var textFormat : TextFormat = defaultFlashTextFormat;
			textFormat.size = size;
			textFormat.color = color;
			// limit to system fonts
			switch( font.toLocaleLowerCase() )
			{
				// serif
				case "times new roman" :
				case "georgia" :
				case "_serif" :
				// sans serif
				case "helvetica" :
				case "helveticaneue-condensedbold" :
				case "arial" :
				case "verdana" :
				case "trebuchet" :
				case "tahoma" :
				case "_sans" :
				// fixed width
				case "courier new" :
				case "courier" :
				case "_typewriter" :
					textFormat.font = font;
					break;
				default :
					textFormat.font = "Helvetica";
			}
			return textFormat;
		}

		public static function get defaultFlashTextFormat() : TextFormat
		{
			// this is literally the default TextFormat that Flash uses
			var textFormat : TextFormat = new TextFormat();
			textFormat.align = "left";                //
			textFormat.blockIndent = 0;               //
			textFormat.bold = false;                  //
			textFormat.bullet = false;                //
			textFormat.color = 0x000000;              //
			textFormat.font = "Times New Roman";      //  (default font is Times on Mac OS X)
			textFormat.indent = 0;                    //
			textFormat.italic = false;                //
			textFormat.kerning = false;               //
			textFormat.leading = 0;                   //
			textFormat.leftMargin = 0;                //
			textFormat.letterSpacing = 0;             //
			textFormat.rightMargin = 0;               //
			textFormat.size = 12;                     //
			textFormat.tabStops = [];                 //  (empty array)
			textFormat.target = "";                   //  (empty string)
			textFormat.underline = false;             //
			textFormat.url = "";                      //  (empty string)
			return textFormat;
		}

		/*
		font name							iPhone ver	iPad  ver
		AcademyEngravedLetPlain				5.0			4.3
		American Typewriter
		AmericanTypewriter					3.0			4.3
		AmericanTypewriter-Bold				3.0			4.3
		AmericanTypewriter-Condensed			5.0			5.0
		AmericanTypewriter-CondensedBold		5.0			5.0
		AmericanTypewriter-CondensedLight	5.0			5.0
		AmericanTypewriter-Light				5.0			5.0
		Apple Color Emoji
		AppleColorEmoji						3.0			4.3
		Apple SD Gothic Neo
		AppleSDGothicNeo-Bold				5.0			5.0
		AppleSDGothicNeo-Medium				4.3			4.3
		Arial
		ArialMT								3.0			4.3
		Arial-BoldItalicMT					3.0			4.3
		Arial-BoldMT							3.0			4.3
		Arial-ItalicMT						3.0			4.3
		Arial Hebrew
		ArialHebrew							3.0			4.3
		ArialHebrew-Bold	3.0	4.3
		Arial Rounded MT Bold
		ArialRoundedMTBold	3.0	4.3
		Avenir
		Avenir-Black	6.0	6.0
		Avenir-BlackOblique	6.0	6.0
		Avenir-Book	6.0	6.0
		Avenir-BookOblique	6.0	6.0
		Avenir-Heavy	6.0	6.0
		Avenir-HeavyOblique	6.0	6.0
		Avenir-Light	6.0	6.0
		Avenir-LightOblique	6.0	6.0
		Avenir-Medium	6.0	6.0
		Avenir-MediumOblique	6.0	6.0
		Avenir-Oblique	6.0	6.0
		Avenir-Roman	6.0	6.0
		Avenir Next
		AvenirNext-Bold	6.0	6.0
		AvenirNext-BoldItalic	6.0	6.0
		AvenirNext-DemiBold	6.0	6.0
		AvenirNext-DemiBoldItalic	6.0	6.0
		AvenirNext-Heavy	6.0	6.0
		AvenirNext-HeavyItalic	6.0	6.0
		AvenirNext-Italic	6.0	6.0
		AvenirNext-Medium	6.0	6.0
		AvenirNext-MediumItalic	6.0	6.0
		AvenirNext-Regular	6.0	6.0
		AvenirNext-UltraLight	6.0	6.0
		AvenirNext-UltraLightItalic	6.0	6.0
		Avenir Next Condensed
		AvenirNextCondensed-Bold	6.0	6.0
		AvenirNextCondensed-BoldItalic	6.0	6.0
		AvenirNextCondensed-DemiBold	6.0	6.0
		AvenirNextCondensed-DemiBoldItalic	6.0	6.0
		AvenirNextCondensed-Heavy	6.0	6.0
		AvenirNextCondensed-HeavyItalic	6.0	6.0
		AvenirNextCondensed-Italic	6.0	6.0
		AvenirNextCondensed-Medium	6.0	6.0
		AvenirNextCondensed-MediumItalic	6.0	6.0
		AvenirNextCondensed-Regular	6.0	6.0
		AvenirNextCondensed-UltraLight	6.0	6.0
		AvenirNextCondensed-UltraLightItalic	6.0	6.0
		Bangla Sangam MN
		BanglaSangamMN	3.0	4.3
		BanglaSangamMN-Bold	3.0	4.3
		Baskerville
		Baskerville	3.0	4.3
		Baskerville-Bold	3.0	4.3
		Baskerville-BoldItalic	3.0	4.3
		Baskerville-Italic	3.0	4.3
		Baskerville-SemiBold	5.0	5.0
		Baskerville-SemiBoldItalic	5.0	5.0
		Bodoni Ornaments
		BodoniOrnamentsITCTT	5.0	4.3
		Bodoni 72
		BodoniSvtyTwoITCTT-Bold	5.0	4.3
		BodoniSvtyTwoITCTT-Book	5.0	4.3
		BodoniSvtyTwoITCTT-BookIta	5.0	4.3
		Bodoni 72 Oldstyle
		BodoniSvtyTwoOSITCTT-Bold	5.0	4.3
		BodoniSvtyTwoOSITCTT-Book	5.0	4.3
		BodoniSvtyTwoOSITCTT-BookIt	5.0	4.3
		BodoniSvtyTwoSCITCTT-Book	5.0	4.3
		Bradley Hand
		BradleyHandITCTT-Bold	6.0	4.3
		Chalkboard SE
		ChalkboardSE-Bold	3.0	4.3
		ChalkboardSE-Light	5.0	5.0
		ChalkboardSE-Regular	3.0	4.3
		Chalkduster
		Chalkduster	5.0	4.3
		Cochin
		Cochin	3.0	4.3
		Cochin-Bold	3.0	4.3
		Cochin-BoldItalic	3.0	4.3
		Cochin-Italic	3.0	4.3
		Copperplate
		Copperplate	5.0	4.3
		Copperplate-Bold	5.0	4.3
		Copperplate-Light	5.0	5.0
		Courier
		Courier	3.0	4.3
		Courier-Bold	3.0	4.3
		Courier-BoldOblique	3.0	4.3
		Courier-Oblique	3.0	4.3
		Courier New
		CourierNewPS-BoldItalicMT	3.0	4.3
		CourierNewPS-BoldMT	3.0	4.3
		CourierNewPS-ItalicMT	3.0	4.3
		CourierNewPSMT	3.0	4.3
		DB LCD Temp
		DBLCDTempBlack	6.0
		3.0	6.0
		4.3
		Devanagari Sangam MN
		DevanagariSangamMN	3.0	4.3
		DevanagariSangamMN-Bold	3.0	4.3
		Didot
		Didot	5.0	4.3
		Didot-Bold	5.0	4.3
		Didot-Italic	5.0	4.3
		Euphemia UCAS
		EuphemiaUCAS	5.0	5.0
		EuphemiaUCAS-Bold	5.0	5.0
		EuphemiaUCAS-Italic	5.0	5.0
		Futura
		Futura-CondensedExtraBold	3.0	4.3
		Futura-CondensedMedium	5.0	5.0
		Futura-Medium	3.0	4.3
		Futura-MediumItalic	3.0	4.3
		Geeza Pro
		GeezaPro	3.0	4.3
		GeezaPro-Bold	3.0	4.3
		Georgia
		Georgia	3.0	4.3
		Georgia-Bold	3.0	4.3
		Georgia-BoldItalic	3.0	4.3
		Georgia-Italic	3.0	4.3
		Gill Sans
		GillSans	5.0	4.3
		GillSans-Bold	5.0	4.3
		GillSans-BoldItalic	5.0	4.3
		GillSans-Italic	5.0	4.3
		GillSans-Light	5.0	5.0
		GillSans-LightItalic	5.0	5.0
		Gujarati Sangam MN
		GujaratiSangamMN	3.0	4.3
		GujaratiSangamMN-Bold	3.0	4.3
		Gurmukhi MN
		GurmukhiMN	3.0	4.3
		GurmukhiMN-Bold	3.0	4.3
		Heiti SC
		STHeitiSC-Light	3.0	4.3
		STHeitiSC-Medium	3.0	4.3
		Heiti TC
		STHeitiTC-Light	3.0	4.3
		STHeitiTC-Medium	3.0	4.3
		Helvetica
		Helvetica	3.0	4.3
		Helvetica-Bold	3.0	4.3
		Helvetica-BoldOblique	3.0	4.3
		Helvetica-Light	5.0	5.0
		Helvetica-LightOblique	5.0	5.0
		Helvetica-Oblique	3.0	4.3
		Helvetica Neue
		HelveticaNeue	3.0	4.3
		HelveticaNeue-Bold	3.0	4.3
		HelveticaNeue-BoldItalic	3.0	4.3
		HelveticaNeue-CondensedBlack	5.0	5.0
		HelveticaNeue-CondensedBold	5.0	5.0
		HelveticaNeue-Italic	3.0	4.3
		HelveticaNeue-Light	5.0	5.0
		HelveticaNeue-LightItalic	5.0	5.0
		HelveticaNeue-Medium	5.0	5.0
		HelveticaNeue-UltraLight	5.0	5.0
		HelveticaNeue-UltraLightItalic	5.0	5.0
		Hiragino Kaku Gothic ProN
		HiraKakuProN-W3	3.0	4.3
		HiraKakuProN-W6	5.0	4.3
		Hiragino Mincho ProN
		HiraMinProN-W3	3.0	4.3
		HiraMinProN-W6	3.0	4.3
		Hoefler Text
		HoeflerText-Black	5.0	4.3
		HoeflerText-BlackItalic	5.0	4.3
		HoeflerText-Italic	5.0	4.3
		HoeflerText-Regular	5.0	4.3
		Kailasa
		Kailasa	3.0	4.3
		Kailasa-Bold	3.0	4.3
		Kannada Sangam MN
		KannadaSangamMN	3.0	4.3
		KannadaSangamMN-Bold	3.0	4.3
		Malayalam Sangam MN
		MalayalamSangamMN	3.0	4.3
		MalayalamSangamMN-Bold	3.0	4.3
		Marion
		Marion-Bold	5.0	5.0
		Marion-Italic	5.0	5.0
		Marion-Regular	5.0	5.0
		Marker Felt
		MarkerFelt-Thin	3.0	4.3
		MarkerFelt-Wide	3.0	4.3
		Noteworthy
		Noteworthy-Bold	5.0	5.0
		Noteworthy-Light	5.0	5.0
		Optima
		Optima-Bold	5.0	4.3
		Optima-BoldItalic	5.0	4.3
		Optima-ExtraBlack	5.0	5.0
		Optima-Italic	5.0	4.3
		Optima-Regular	5.0	4.3
		Oriya Sangam MN
		OriyaSangamMN	3.0	4.3
		OriyaSangamMN-Bold	3.0	4.3
		Palatino
		Palatino-Bold	3.0	4.3
		Palatino-BoldItalic	3.0	4.3
		Palatino-Italic	3.0	4.3
		Palatino-Roman	3.0	4.3
		Papyrus
		Papyrus	5.0	4.3
		Papyrus-Condensed	3.0	5.0
		Party LET
		PartyLetPlain	5.0	4.3
		Sinhala Sangam MN
		SinhalaSangamMN	3.0	4.3
		SinhalaSangamMN-Bold	3.0	4.3
		Snell Roundhand
		SnellRoundhand	3.0	4.3
		SnellRoundhand-Black	5.0	5.0
		SnellRoundhand-Bold	3.0	4.3
		Symbol
		Symbol	6.0	6.0
		Tamil Sangam MN
		TamilSangamMN	3.0	4.3
		TamilSangamMN-Bold	3.0	4.3
		Telugu Sangam MN
		TeluguSangamMN	3.0	4.3
		TeluguSangamMN-Bold	3.0	4.3
		Thonburi
		Thonburi	3.0	4.3
		Thonburi-Bold	3.0	4.3
		Times New Roman
		TimesNewRomanPS-BoldItalicMT	3.0	4.3
		TimesNewRomanPS-BoldMT	3.0	4.3
		TimesNewRomanPS-ItalicMT	3.0	4.3
		TimesNewRomanPSMT	3.0	4.3
		Trebuchet MS
		Trebuchet-BoldItalic	3.0	4.3
		TrebuchetMS	3.0	4.3
		TrebuchetMS-Bold	3.0	4.3
		TrebuchetMS-Italic	3.0	4.3
		Verdana
		Verdana	3.0	4.3
		Verdana-Bold	3.0	4.3
		Verdana-BoldItalic	3.0	4.3
		Verdana-Italic	3.0	4.3
		Zapf Dingbats
		ZapfDingbatsITC	5.0	4.3
		Zapfino
		Zapfino
		 */
	}
}
