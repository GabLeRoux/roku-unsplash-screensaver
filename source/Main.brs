Function RunScreenSaver( params As Object ) As Object
    showChannelSGScreen()
End Function

sub Main()
    screen = createObject("roSGScreen")
    port = createObject("roMessagePort")
    port2 =  createObject("roMessagePort")
    screen.setMessagePort(port)

    m.global = screen.getGlobalNode() 'Creates (Global) variable MyField
    m.global.AddField("newImageUrl", "string", true) 'Creates (Global) variable newImageUrl
    m.global.newImageUrl = GetImageUrl()
    m.global.AddField("PicSwap", "int", true) 'Creates (Global) variable PicSwap
    m.global.PicSwap = 0

    scene = screen.createScene("ScreensaverFade") 'Creates scene ScreensaverFade
    screen.show()

    delayPerPicture = 7000
    delayBeforeFading = 2500

    ' trigger first picture swap
    m.global.PicSwap += 1

    while(true) 'Message Port that fires every 7 seconds to change value of MyField if the screen isn't closed
        msg = wait(delayPerPicture, port)
        if (msg <> invalid)
            msgType = type(msg)
            if msgType = "roSGScreenEvent"
                if msg.isScreenClosed() then return
            end if
        else
            ' TODO: store to tmp:/ or something like that
            m.global.newImageUrl = GetImageUrl()
            msg = wait(delayBeforeFading, port2)
            m.global.PicSwap += 1
        end if
    end while
end sub

Function GetImageUrl()
    print "GetImageUrl"

    di = CreateObject("roDeviceInfo")
    displayMode = di.GetDisplayMode()
    print "DisplayMode: " + di.GetDisplayMode()
    print "VideoMode: " + di.GetDisplayMode()

    width = int(di.GetDisplaySize().w)
    height = int(di.GetDisplaySize().h)

    print "width: " + width.toStr()
    print "height: " + height.toStr()

    ' This is a workaround to reduce occurences of following issue: https://github.com/GabLeRoux/roku-unsplash-screensaver/issues/3
    keywords = [
        "cats",
        "water",
        "space",
        "landscape"
        "cats,water",
        "landscape,space",
        "nature",
        "cats,nature",
        "wallpaper",
        "yoga",
        "sunrise",
        "forest",
        "coffee",
        "sky",
    ]
    number_of_keywords = 14 ' that's only because I don't know how to len(keywords), gotta learn Birghtscript
    randomImageUrl = "https://source.unsplash.com/" + width.toStr() + "x" + height.toStr() + "/"

    keywords_params = keywords[Rnd(number_of_keywords) - 1]
    ' randomize url so device doesn't think we're requesting always the same url everytime
    newImageUrl = randomImageUrl + "?" + keywords_params + "#" + Rnd(1000).toStr()
    print newImageUrl
    return newImageUrl
End Function
