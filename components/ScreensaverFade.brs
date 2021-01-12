Function changeBackground() as Void 'Function that changes the background image to the next image in the m.pictures array
    m.BackgroundArt.uri = m.global.newImageUrl
End Function

Function FadeAnimation() as Void 'Function that starts the FadeAnimation transition animation
    m.FadeAnimation.control = "start"
End Function

Function init()
    m.FadeAnimation = m.top.findNode("FadeAnimation") 'Sets pointer to FadeAnimation node
    m.BackgroundArt = m.top.findNode("BackgroundArt") 'Sets pointer to BackgroundArt node
'    m.BackgroundArt.uri = m.pictures[0] 'Sets Background art to first picture

    m.global.observeField("PicSwap", "changeBackground") 'field Observer that calls changeBackground() function everytime the value of PicSwap is changed
    m.global.observeField("MyField", "FadeAnimation")  'field Observer that calls FadeAnimation() function everytime the value of MyField is changed
    m.global.observeField("newImageUrl", "FadeAnimation")  'field Observer that calls FadeAnimation() function everytime the value of MyField is changed
End Function

