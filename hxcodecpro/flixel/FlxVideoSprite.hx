package hxcodecpro.flixel;

import hxcodecpro.openfl.VideoBitmap;
import flixel.util.FlxSignal;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import hxcodec.openfl.VideoSprite;

/**
 * An FlxSprite which displays a video.
 */
class FlxVideoSprite extends FlxSprite
{
  /**
   * Set this value to enforce a specific canvas width for the video.
   */
  public var canvasWidth:Null<Int> = null;

  /**
   * Set this value to enforce a specific canvas height for the video.
   */
  public var canvasHeight:Null<Int> = null;

  /**
   * A signal dispatched when the video is opened.
   * Call `onVideoOpen.add()` to add a callback.
   */
  public var onVideoOpen:FlxSignal;

  /**
   * A signal dispatched when the video is completed.
   * Call `onVideoComplete.add()` to add a callback.
   */
  public var onVideoComplete:FlxSignal;

  /**
   * A signal dispatched when the video's graphic is loaded.
   * Call `onGraphicLoaded.add()` to add a callback.
   */
  public var onGraphicLoaded:FlxSignal;

  /**
   * The bitmap used to display the video internally.
   */
  var video:VideoBitmap;

  var videoInitialized:Bool;

  public function new(X:Float = 0, Y:Float = 0)
  {
    super(X, Y);

    // Create a placeholder graphic.
    makeGraphic(1, 1, FlxColor.TRANSPARENT);

    onVideoOpen = new FlxSignal();
    onVideoComplete = new FlxSignal();
    onGraphicLoaded = new FlxSignal();

    video = new VideoBitmap();
    video.visible = false;

    video.onOpening = () -> {
      onVideoOpen.dispatch();
    };
    video.onEndReached = () -> {
      onVideoComplete.dispatch();
    };
  }

  public function playVideo(path:String, loop:Bool = false, shouldPauseMusic:Bool = true):Void
  {
    video.play(path, loop, shouldPauseMusic);
  }

  public override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (!videoInitialized && video.isPlaying && video.isDisplaying && video.bitmapData != null)
    {
      var graphic:FlxGraphic = FlxG.bitmap.add(video.bitmapData, false, video.mrl);
      if (graphic.imageFrame.frame == null)
      {
        return;
      }

      loadGraphic(graphic);

      if (canvasWidth != null && canvasHeight != null)
      {
        setGraphicSize(canvasWidth, canvasHeight);
        updateHitbox();
      }

      onGraphicLoaded.dispatch();

      videoInitialized = true;
    }
  }
}
