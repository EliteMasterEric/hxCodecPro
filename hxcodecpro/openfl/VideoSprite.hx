package hxcodecpro.openfl;

import openfl.events.Event;
import openfl.Lib;
import openfl.display.Sprite;

/**
 * An OpenFL sprite which displays a video.
 */
class VideoSprite extends Sprite
{
  /**
   * The bitmap used to display the video internally.
   */
  var video:VideoBitmap;

  public var autoResize:Bool = false;

  public function new()
  {
    super();

    video = new VideoBitmap();
    addChild(video);
  }

  /**
   * Play a video from a local file path.
   * @param path The path to the video file.
   * @param loop Whether or not the video should loop.
   */
  public function playVideo(path:String, loop:Bool = false):Void
  {
    // in case if you want to use another dir then the application one.
    // android can already do this, it can't use application's storage.
    if (sys.FileSystem.exists(Sys.getCwd() + path))
    {
      video.play(Sys.getCwd() + path, loop, false);
    }
    else
    {
      video.play(path, loop, false);
    }

    stage.addEventListener(Event.ENTER_FRAME, update);
  }

  function update(e:Event):Void
  {
    if (autoResize)
    {
      width = calcWidth();
      height = calcHeight();
    }
  }

  /**
   * Play a video from a URL.
   * @param url The URL to the video file.
   * @param loop Whether or not the video should loop.
   */
  public function playVideoFromUrl(url:String, loop:Bool = false):Void
  {
    video.play(url, loop, true);
  }

  /**
   * Calculate the width of the current OpenFL stage.
   * @return Width in pixels.
   */
  function calcWidth():Int
  {
    var appliedWidth:Float = Lib.current.stage.stageHeight;

    #if flixel
    appliedWidth *= (flixel.FlxG.width / flixel.FlxG.height);
    #end

    if (appliedWidth > Lib.current.stage.stageHeight) appliedWidth = Lib.current.stage.stageHeight;

    return Std.int(appliedWidth);
  }

  /**
   * Calculate the height of the current OpenFL stage.
   * @return Height in pixels.
   */
  function calcHeight():Int
  {
    var appliedHeight:Float = Lib.current.stage.stageWidth;

    #if flixel
    appliedHeight *= (flixel.FlxG.height / flixel.FlxG.width);
    #end

    if (appliedHeight > Lib.current.stage.stageHeight) appliedHeight = Lib.current.stage.stageHeight;

    return Std.int(appliedHeight);
  }
}
