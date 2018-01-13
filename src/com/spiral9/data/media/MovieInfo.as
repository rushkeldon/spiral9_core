package com.spiral9.data.media
{

	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.StringService;
	public class MovieInfo
	{
		public var movieID : String;
		public var title : String;
		public var year : String;
		public var rated : String;
		public var mpRating : String;
		public var starRating : Number;
		public var genre : String;
		public var copyright : String;
		public var director : String;
		public var writer : String;
		public var cast : String;
		public var synopsis : String;
		public var fbURL : String;
		public var siteURL : String;
		public var infoURL : String;
		public var purchaseURL : String;
		public var posterURL : String;

		public function MovieInfo( initObject : Object = null )
		{
			/*
			"VideoInfo":{
				"id":"field_of_dreams_0001_246x138",
				"url":"\/\/com.spiral9.assets.s3.amazonaws.com\/vid\/field_of_dreams_0001_246x138.mp4",
				"width":"246",
				"height":"138",
				"MovieInfo":{
					"title":"Field of Dreams",
					"year":"1989",
					"mpRating":"PG",
					"starRating":4.5,
					"genre":"Drama",
					"copyright":"\u00a9 2008 Universal Studios All Rights Reserved.",
					"director":"Phil Alden Robinson",
					"writer":"Phil Alden Robinson",
					"cast":"Kevin Costner,Amy Madigan,James Earl Jones,Burt Lancaster,Ray Liotta",
					"synopsis":"\"If you build it, he will come.\" With these words, Iowa farmer Ray Kinsella (Kevin Costner) is inspired by a voice he can't ignore to pursue a dream he can hardly believe. Also starring Ray Liotta, James Earl Jones, and Amy Madigan, Field of Dreams is an extraordinary and unforgettable experience that has moved critics and audiences like no other film of its generation. Field of Dreams is a glowing tribute to all who dare to dream.",
					"fbURL":"",
					"siteURL":"",
					"posterURL":"",
					"purchaseURL":"http:\/\/www.amazon.com\/dreams-widescreen-two-disc-anniversary-edition\/dp\/078322611x\/ref=sr_1_2?s=movies-tv&ie=utf8&qid=1331679746&sr=1-2"
				}
			*/

			title = Conversion.assignProp( initObject, "title", "noTitle" );
			year = Conversion.assignProp( initObject, "year", "noYear" );
			mpRating = Conversion.assignProp( initObject, "mpRating", "PG" );
			starRating = Conversion.assignProp( initObject, "starRating", 0 );
			genre = Conversion.assignProp( initObject, "genre", "Drama" );
			copyright = Conversion.assignProp( initObject, "copyright", "\u00a9 2008 Universal Studios All Rights Reserved." );
			director = Conversion.assignProp( initObject, "director", "" );
			writer = Conversion.assignProp( initObject, "writer", "" );
			cast = Conversion.assignProp( initObject, "cast", "" );
			synopsis = Conversion.assignProp( initObject, "synopsis", "" );
			fbURL = Conversion.assignProp( initObject, "fbURL", "http://facebook.com" );
			siteURL = Conversion.assignProp( initObject, "siteURL", "http://hollywoodplayer.com" );
			posterURL = Conversion.assignProp( initObject, "posterURL", "" );
			purchaseURL = Conversion.assignProp( initObject, "purchaseURL", "http://amazon.com" );
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "MovieInfo :\n";
			str += indent + "\t• movieID :\t\t" + String( movieID ) + "\n";
			str += indent + "\t• title :\t\t" + String( title ) + "\n";
			str += indent + "\t• genre :\t\t" + String( genre ) + "\n";
			str += indent + "\t• year :\t\t" + String( year ) + "\n";
			str += indent + "\t• director :\t\t" + String( director ) + "\n";
			str += indent + "\t• cast :\t\t" + String( cast ) + "\n";
			str += indent + "\t• writer :\t\t" + String( writer ) + "\n";
			str += indent + "\t• mpRating :\t\t" + String( mpRating ) + "\n";
			str += indent + "\t• rated :\t\t" + String( rated ) + "\n";
			str += indent + "\t• starRating :\t\t" + String( starRating ) + "\n";
			str += indent + "\t• synopsis :\t\t" + String( synopsis ) + "\n";
			str += indent + "\t• copyright :\t\t" + String( copyright ) + "\n";
			str += indent + "\t• posterURL :\t\t" + String( posterURL ) + "\n";
			str += indent + "\t• infoURL :\t\t" + String( infoURL ) + "\n";
			str += indent + "\t• fbURL :\t\t" + String( fbURL ) + "\n";
			str += indent + "\t• siteURL :\t\t" + String( siteURL ) + "\n";
			str += indent + "\t• purchaseURL :\t\t" + String( purchaseURL );
			return( str );
		}

		public function toObject() : Object
		{
			var o : Object = new Object();

			o.movieID = movieID;
			o.title = title;
			o.year = year;
			o.rated = rated;
			o.mpRating = mpRating;
			o.mpRating = mpRating;
			o.genre = genre;
			o.genre = genre;
			o.director = director;
			o.writer = writer;
			o.cast = cast;
			o.synopsis = synopsis;
			o.fbURL = fbURL;
			o.siteURL = siteURL;
			o.siteURL = siteURL;
			o.purchaseURL = purchaseURL;
			o.posterURL = posterURL;

			return o;
		}
	}
}
