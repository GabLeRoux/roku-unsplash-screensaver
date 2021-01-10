sub Main()
    RunScreenSaver()
end sub

Sub RunScreenSaver()
    print "Starting screensaver"
    waitDelay = 15000

    di = CreateObject("roDeviceInfo")
    displayMode = di.GetDisplayMode()

    width = int(di.GetDisplaySize().w)
    height = int(di.GetDisplaySize().h)
    xpos = 0
    ypos = 0

    randomImageUrl = "https://source.unsplash.com/" + width.toStr() + "x" + height.toStr() + "/?nature,water,pets,cats,landscape,space,landscape,sunset"

    canvas = CreateObject("roImageCanvas")
    port = CreateObject("roMessagePort")
    canvas.SetMessagePort(port)
    canvas.SetLayer(0, {Color:"#FF000000", CompositionMode:"Source"})
    canvas.SetRequireAllImagesToDraw(false)

    while(true)
        ' randomize url so device doesn't think we're requesting always the same url everytime
        newImageUrl = randomImageUrl + "#" + Rnd(65534).toStr()

        canvasItems = [
            {
                url: newImageUrl
                TargetRect:{x:xpos,y:ypos,w:width,h:height}
            }
        ]
        canvas.SetLayer(1, canvasItems)
        canvas.Show()

        msg = wait(waitDelay, port)
        if type(msg) = "roImageCanvasEvent" then
            if (msg.isRemoteKeyPressed()) then
                return
            end if
        end if
    end while
End Sub

'Function fetch_JSON(url as string) as Object
'    print "fetch_JSON"
'    print url
'    xfer=createobject("roURLTransfer")
'    xfer.seturl(url)
'    data=xfer.gettostring()
'    json = ParseJSON(data)
'    return json
'End Function
