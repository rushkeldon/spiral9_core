package com.spiral9.core
{
	import com.spiral9.assets.BtnPause;
	import com.spiral9.assets.BtnPlay;
	import com.spiral9.assets.NoImages;
	import com.spiral9.assets.ProgressBar;
	import com.spiral9.assets.VideoHourglass;
	import com.spiral9.data.ButtonInfo;
	import com.spiral9.data.ColorValues;
	import com.spiral9.data.DialogInfo;
	import com.spiral9.data.EndScreenInfo;
	import com.spiral9.data.ErrorInfo;
	import com.spiral9.data.FileInfo;
	import com.spiral9.data.GameInfo;
	import com.spiral9.data.SWFassetInfo;
	import com.spiral9.data.SessionInfo;
	import com.spiral9.data.SmartLinkInfo;
	import com.spiral9.data.StatusChangeInfo;
	import com.spiral9.data.TextInfo;
	import com.spiral9.data.TimerInfo;
	import com.spiral9.data.URLinfo;
	import com.spiral9.data.commerce.CouponInfo;
	import com.spiral9.data.commerce.DigitalGoodInfo;
	import com.spiral9.data.commerce.DigitalGoodInventoryInfo;
	import com.spiral9.data.media.MovieInfo;
	import com.spiral9.data.media.SoundInfo;
	import com.spiral9.data.media.VideoInfo;
	import com.spiral9.media.StageVideoPanel;
	import com.spiral9.media.VideoPanelSimple;
	import com.spiral9.net.FileService;
	import com.spiral9.sn.FBcore;
	import com.spiral9.utils.Alignment;
	import com.spiral9.utils.BitmapHitTest;
	import com.spiral9.utils.BitmapUtil;
	import com.spiral9.utils.CSV;
	import com.spiral9.utils.ContextMenuHWP;
	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.FUIDgen;
	import com.spiral9.utils.MovieClipUtil;
	import com.spiral9.utils.StageReference;
	import com.spiral9.utils.StringUtils;
	import com.spiral9.utils.TimeKeeper;
	import com.spiral9.utils.Tinter;
	import com.spiral9.ux.BaseUI;
	import com.spiral9.ux.Buttonizer;
	import com.spiral9.ux.DynaButton;
	import com.spiral9.ux.SWFasset;
	import com.spiral9.ux.SkinnableUI;
	import com.spiral9.ux.SmartLink;

	import flash.display.Sprite;


	public class SPIRAL9_CORE extends Sprite
	{
		public static var CN : String = "SPIRAL9_CORE[2014_03_15_12_45]";

		public function SPIRAL9_CORE()
		{
			var includes : Array = [
				Alignment,
				BaseUI,
				BitmapHitTest,
				BitmapUtil,
				BtnPause,
				BtnPlay,
				ButtonInfo,
				Buttonizer,
				CSV,
				ColorValues,
				ContextMenuHWP,
				Conversion,
				CouponInfo,
				DialogInfo,
				DigitalGoodInfo,
				DigitalGoodInventoryInfo,
				DynaButton,
				EndScreenInfo,
				ErrorAuthority,
				ErrorInfo,
				FBcore,
				FUIDgen,
				FileInfo,
				FileService,
				GameInfo,
				MovieClipUtil,
				MovieInfo,
				NoImages,
				ProgressBar,
				ProgressBar,
				SWFasset,
				SWFassetInfo,
				SWFassetInfo,
				SessionInfo,
				SkinnableUI,
				SmartLink,
				SmartLinkInfo,
				SoundInfo,
				StageReference,
				StageVideoPanel,
				StatusChangeInfo,
				StringUtils,
				TextInfo,
				TimeKeeper,
				TimerInfo,
				Tinter,
				URLinfo,
				VideoHourglass,
				VideoHourglass,
				VideoInfo,
				VideoPanelSimple
				];

				var sounds : Array = [

				];
		}
	}
}
