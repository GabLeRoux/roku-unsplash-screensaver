Function RunScreenSaver( params As Object ) As Object
    showChannelSGScreen()
End Function

sub Main()
    screen = createObject("roSGScreen")
    port = createObject("roMessagePort")
    port2 =  createObject("roMessagePort")
    screen.setMessagePort(port)

    m.global = screen.getGlobalNode() 'Creates (Global) variable MyField
    m.global.AddField("MyField", "int", true)
    m.global.MyField = 0
    m.global.AddField("PicSwap", "int", true) 'Creates (Global) variable PicSwap
    m.global.PicSwap = 0
    m.global.AddField("newImageUrl", "string", true) 'Creates (Global) variable newImageUrl
    m.global.newImageUrl = ""

    scene = screen.createScene("ScreensaverFade") 'Creates scene ScreensaverFade
    screen.show()

    while(true) 'Message Port that fires every 7 seconds to change value of MyField if the screen isn't closed
        msg = wait(7000, port)
        if (msg <> invalid)
            msgType = type(msg)
            if msgType = "roSGScreenEvent"
                if msg.isScreenClosed() then return
            end if
        else
            m.global.MyField += 10
            downloadImage()
            msg = wait(2500, port2) 'Message port that fires 4 seconds after MyField is changed. Must be set to different port than other wait function or it will interfere.
            m.global.PicSwap += 10
        end if
    end while
end sub

Function downloadImage()
    print "downloadImage"

    '    width = 3840
    '    height = 2160

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
    m.global.newImageUrl = newImageUrl
End Function

'Function fetch_JSON(url as string) as Object
'    print "fetch_JSON"
'    print url
'    xfer=createobject("roURLTransfer")
'    xfer.seturl(url)
'    data=xfer.gettostring()
'    json = ParseJSON(data)
'    return json
'End Function
