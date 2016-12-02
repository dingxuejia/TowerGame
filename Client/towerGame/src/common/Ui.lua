--创建ui控件的辅助函数
require("cocos.ui.GuiConstants")

ui = {}

-- 创建 ccui.Button
--[[
    params:
    Table params:
    {
        normalImage      : 正常图片，必须提供
        lightedImage     : 按下图片，可选设置，默认为normal
        disabledImage    : 不可用时图片，可选设置，默认为normal
        size        : 按钮大小，可选设置，默认为normal图片大小
        position    : 按钮位置, 可选设置，默认为(0，0)点
        clickAction : 点击事件，可选设置
        clickIsChange:   点击是否变大，可选设置，默认为true变大
        clickAudio  : 点击音效(clickAction有效)，默认为ButtonAudio.normal, 设置为""可取消音效
        text        : 显示的字符串(必须和fontSize同时提供)，可选设置
        fontSize    : 显示的字符串字体大小(必须和text同时提供)，可选设置
        fontName    : 字体名，可选设置，默认为 _FONT_DEFAULT
        textColor   : 字体颜色，可选设置
        outlineColor = nil, -- 文字描边的颜色，可选设置，不设置表示不需要描边
        outlineSize = 1,    -- 文字描边的大小，可选设置，如果 outlineColor 为nil，该参数无效，默认为 2

        titleImage  : 按钮上的图片，可选设置
        anchorPoint : 可选设置
        scale       : 可选设置

        titlePosRateX   : title图片或文字的X坐标相对按钮宽度的比例，默认为0.5
        titlePosRateY   : title图片或文字的Y坐标相对按钮高度的比例，默认为0.5
    }
--]]
function ui.newButton(params)
    if not params or not params.normalImage then
        return
    end
    if params.textureResType and params.texturePlist and params.texturePlist ~= "" then
        cc.SpriteFrameCache:getInstance():addSpriteFrames(params.texturePlist)
    end

    local lightedImage = params.lightedImage or params.selectedImage or params.normalImage
    local disabledImage = params.disabledImage or ""
    local button = ccui.Button:create(params.normalImage, lightedImage, disabledImage, params.textureResType or ccui.TextureResType.localType)
    button:setPressedActionEnabled(true)

    if params.size then
        button:setScale9Enabled(true)
        button:setContentSize(params.size)
    else
        -- if params.text and not params.fixedSize then
        --     local textCount = string.utf8len(params.text)
        --     local size = ButtonSize[textCount]
        --     if size then
        --         button:setScale9Enabled(true)
        --         button:setContentSize(size)
        --     end
        -- end
    end

    local titlePosRateX = params.titlePosRateX or 0.5
    local titlePosRateY = params.titlePosRateY or 0.5
    local buttonSize = button:getContentSize()

    --button:getExtendNode2():setPosition(buttonSize.width/2, buttonSize.height/2)

    -- 判断是否带字符串显示·
    if params.text then
        local tempStr = params.text
        if string.utf8len(tempStr) == 2 then
            tempStr = string.utf8sub(params.text, 1, 1) .. " " .. string.utf8sub(params.text, 2, 2)
        end
        local titleLabel = ui.newLabel({
            text = tempStr,
            font = params.fontName or Enums.Font.eDefault,
            size = params.fontSize or Enums.Fontsize.eBtnDefault,
            color = params.textColor or Enums.Color.eBtnText,
            shadowColor = params.shadowColor,
            outlineColor = params.outlineColor,
            outlineSize = params.outlineSize,
            x = buttonSize.width * (titlePosRateX - 0.5),
            y = buttonSize.height * (titlePosRateY - 0.5),
            dimensions = params.textWidth and cc.size(params.textWidth, 0),
        })
        titleLabel:setAnchorPoint(cc.p(0.5, 0.5))

        --button:getExtendNode2():addChild(titleLabel)
        button:addChild(titleLabel)
        button.mTitleLabel = titleLabel
    end

    -- 创建title image
    if params.titleImage then
        button.titleSprite = ui.newSprite(params.titleImage)
        button.titleSprite:setPosition(buttonSize.width * (titlePosRateX - 0.5), buttonSize.height * (titlePosRateY - 0.5))
        --button:getExtendNode2():addChild(button.titleSprite, 1)
        button:addChild(button.titleSprite, 1)
    end

    -- 修改titleImage
    button.setTitleImage = function(target, titleImage)
        if target.titleSprite == nil then
            target.titleSprite = ui.newSprite(titleImage)
            --target:getExtendNode2():addChild(target.titleSprite, 1)
            target:addChild(target.titleSprite, 1)
        else
            target.titleSprite:setTexture(titleImage)
        end
    end

    -- 设置位置
    if params.position then
        button:setPosition(params.position)
    end

    -- 设置缩放
    if params.scale then
        button:setScale(params.scale)
    end

    -- 设置瞄点
    if params.anchorPoint then
        button:setAnchorPoint(params.anchorPoint)
    end

    -- 修改Label
    function button:setTitleText(text)
        if self.mTitleLabel then
            local tempStr = text
            if string.utf8len(tempStr) == 2 then
                tempStr = string.utf8sub(text, 1, 1) .. " " .. string.utf8sub(text, 2, 2)
            end

            self.mTitleLabel:setString(tempStr)
        end
    end

    -- 修改颜色
    function button:setTitleColor(color)
        if self.mTitleLabel then
            self.mTitleLabel:setTextColor(color)
        end
    end

    function button:setTitleRateY(posRateY)
        local size  = button:getContentSize()
        local y = size.height * (posRateY - 0.5)
        self.mTitleLabel:setPositionY(y)
    end

    -- 定位
    function button:align(anchorPoint, x, y)
        if anchor then
            self:setAnchorPoint(anchor)
        end
        if x and y then
            self:setPosition(x, y)
        end
        return self
    end

    -- 点击事件
    function button:setClickAction(clickAction)
        self.mClickAction = clickAction
    end

    -- 设置点击事件
    button:setClickAction(params.clickAction)

    button:addTouchEventListener(function(sender, event)
        if event == ccui.TouchEventType.began then
            button.mBeginPos = sender:getTouchBeganPosition()
        elseif event == ccui.TouchEventType.ended then
            local beginPos = button.mBeginPos
            local endPos = sender:getTouchEndPosition()
            local distance = math.sqrt(math.pow(endPos.x - beginPos.x, 2) + math.pow(endPos.y - beginPos.y, 2))
            if distance < (40) then
                if not params.clickAudio then
                    --MqAudio.playEffect("button.mp3")
                elseif params.clickAudio ~= "" then
                    --MqAudio.playEffect(params.clickAudio)
                end

                if button.mClickAction then
                    button.mClickAction(button)
                end
            end
        end
    end)

    return button
end

-- 创建 LabelTTF 文字显示对象
--[[
    params:
    Table params:
    {
        text = "",          -- 显示的内容
        font = nil,         -- 显示的字体, 默认为 _FONT_DEFAULT. 当设置为xxx.png时使用createWithCharMap创建.
        size = 24,          -- 显示字体的大小,默认为22号字
        scale = 1,          -- 设置label的字体和dimensions的缩放，默认为1
        color = nil,        -- 显示的颜色，默认为 gex.Enums.Colors.eWhite
        shadowColor = nil,  -- 阴影的颜色，可选设置，不设置表示不需要阴影
        outlineColor = nil, -- 描边的颜色，可选设置，不设置表示不需要描边
        outlineSize = 1,    -- 描边的大小，可选设置，如果 outlineColor 为nil，该参数无效，默认为 1
        align = nil,        -- 水平对齐方式, 默认为 cc.TEXT_ALIGNMENT_LEFT
        valign = nil,       -- 垂直对齐方式，默认为 cc.VERTICAL_TEXT_ALIGNMENT_CENTER
        x = 0,              -- x坐标， 默认为0
        y = 0,              -- y坐标，默认为0
        anchorPoint         -- 锚点，默认为cc.p(0.5, 0.5)
        dimensions = nil,   -- 显示区域大小，默认不设置大小, dimensions.height = 0 的时候，自动计算高度
        charSize = nil,     -- 当font为png时有效，字符的宽高
        startChar = nil,    -- 当font为png时有效，图片中开始字符
    }
--]]
function ui.newLabel(params)
    assert(type(params) == "table", "params must be table")

    local text       = tostring(params.text) or ""
    local font       = params.font or display.DEFAULT_TTF_FONT
    local size       = params.size or display.DEFAULT_TTF_FONT_SIZE
    local textAlign  = params.align or cc.TEXT_ALIGNMENT_LEFT
    local textValign = params.valign or cc.VERTICAL_TEXT_ALIGNMENT_CENTER

    -- 初始化设置label大小
    local dimensions = params.dimensions
    if not dimensions then
        dimensions = cc.size(0, 0)
    end

    local label
    local extension = font:match("%.([^%.]+)$")
    local fontImageMark = text:find(".ttf") or text:find("{[%w_/]+%.[jpngJPNG]+}")
    if not extension and not fontImageMark then
        label = cc.Label:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
    else
        extension = extension and string.lower(extension)
        if extension == "ttf" or fontImageMark then
            -- label = require("common.ImageLabel").new({text=text, font=font, size=size, dimensions=dimensions,
            --     textAlign = textAlign, textValign = textValign, color=params.color, outlineColor= params.outlineColor, outlineSize=params.outlineSize, shadowColor=params.shadowColor})
            -- label.isRichText = true
        elseif extension == "fnt" then
            label = cc.Label:createWithBMFont(font, text, textAlign, 0, cc.p(0, 0))
        elseif extension == "png" and params.charSize then
            label = cc.Label:createWithCharMap(font, params.charSize.width, params.charSize.height, params.startChar)
            label:setString(text)
        end
    end

    -- system label参数设置
    if not label.isRichText then
        if params.color then
            label:setTextColor(params.color)
        end
        if params.outlineColor then
            label:enableOutline(params.outlineColor, params.outlineSize or 1)
        end
        if params.shadowColor then
            label:enableShadow(cc.c4b(params.shadowColor.r,params.shadowColor.g,params.shadowColor.b,255))
        end
        if params.scale then
            label:setSystemFontSize(size * params.scale)
            if params.dimensions then
                label:setDimensions(dimensions.width * params.scale, dimensions.height * params.scale)
            end
        end
    end
    if params.x and params.y then
        label:setPosition(params.x, params.y)
    end
    if params.anchorPoint then
        label:setAnchorPoint(cc.p(params.anchorPoint))
    end
    return label
end

-- 创建 cc.EditBox
--[[
    params:
    Table params:
    {
        backImage   : 背景图片，必须提供
        size        : 按钮大小，必须提供

        maxLength   : 最大字符长度，可选参数，默认不设立
        multiLines  : 是否允许多行, 可选参数, 默认为false
        anchor      : 锚点位置，可选设置
        position    : 按钮位置, 可选设置，默认为(0，0)点
        fontName    : 字体名，可选设置，默认为 _FONT_DEFAULT
        fontSize    : 字体大小，可选设置
        fontColor   : 字体颜色，可选设置
        placeHolder : 提示文字，可选设置
        placeColor  : 提示文字的颜色，可选设置
    }
    说明：请使用getText/setText函数获取/修改编辑框的文字，或者通过 editNode.editBox 来访问editbox的全部接口
--]]
function ui.newEditBox(params)
    local imageNormal = params.backImage
    local isMultiLines = params.multiLines or false
    local imagePressed = params.imagePressed
    local imageDisabled = params.imageDisabled
    local labelAlignment = params.labelAlignment or cc.TEXT_ALIGNMENT_LEFT

    if type(imageNormal) == "string" then
        imageNormal = ccui.Scale9Sprite:create(imageNormal)
        --imageNormal:setPreferredSize(cc.p(510, 240))
    end
    if type(imagePressed) == "string" then
        imagePressed = cc.Scale9Sprite:create(imagePressed)
    end
    if type(imageDisabled) == "string" then
        imageDisabled = cc.Scale9Sprite:create(imageDisabled)
    end
    -- local editbox = ccui.EditBox:create(params.size, isMultiLines, imageNormal, imagePressed, imageDisabled, labelAlignment)
    local editbox = ccui.EditBox:create(params.size, imageNormal, imagePressed, imageDisabled)

    if editbox then
        -- 设置默认回调函数
        params.listener = params.listener or function(event, editbox) end
        editbox:registerScriptEditBoxHandler(params.listener)
        if params.position then
            editbox:setPosition(params.position)
        end
        if params.anchor then
            editbox:setAnchorPoint(params.anchor)
        end
        if params.fontSize then
            local validName = params.fontName or display.DEFAULT_TTF_FONT
            editbox:setFont(validName, params.fontSize)
            editbox:setPlaceholderFont(validName, params.fontSize)
        end
        if params.fontColor then
            editbox:setFontColor(params.fontColor)
        end
        -- 设置提示文字
        if params.placeHolder then
            editbox:setPlaceHolder(params.placeHolder)
        end
        -- 设置提示文字颜色
        if params.placeColor then
            editbox:setPlaceholderFontColor(params.placeColor)
        end

        if params.maxLength then
            editbox:setMaxLength(params.maxLength)
        end
    end

    --保存下背景图
    editbox.imageNormal = imageNormal
    return editbox
end

-- 快捷创建sprite
--[[
    params:
    Table params:
    {
        image="",               -- 必选参数，sprite的图片
        anchor=cc.p(x,y),       -- 可选参数，sprite的显示锚点，默认是cc.p(0.5, 0.5)
        position=cc.p(x,y),     -- 可选参数，sprite的显示位置
        scale=1,                -- 可选参数，sprite的缩放比例，默认是1
    }
    对外开放接口:
    changeImage(newImage)   -- 修改sprite的显示图片
--]]
function ui.newSprite(params)
    if params==nil or params.image==nil then
        return nil
    end

    local retSprite = display.newSprite(params.image)
    -- 设置锚点
    if params.anchor then
        retSprite:setAnchorPoint(params.anchor)
    end
    -- 设置位置
    if params.position then
        retSprite:setPosition(params.position)
    end
    -- 设置缩放比例
    if params.scale then
        retSprite:setScale(params.scale)
    end
    -- 对外提供修改图片的接口
    retSprite.changeImage = function(pSender, newImage)
        retSprite:setTexture(cc.Director:getInstance():getTextureCache():addImage(newImage))
    end
    return retSprite
end

--[[
-- 参数
    filename：图片名称
    contentSize: 需要拉伸的大小
 ]]
function ui.newScale9Sprite(filename, contentSize)
    local sprite
    local tempInfo = scale9Infos[filename]
    local srcSize = shareTextureCache:addImage(filename):getContentSizeInPixels()
    if tempInfo then
        sprite = cc.Scale9Sprite:create(filename, cc.rect(0, 0, srcSize.width, srcSize.height), tempInfo.capRect)
    else
        sprite = cc.Scale9Sprite:create(filename)
    end
    if contentSize then
        sprite:setContentSize(contentSize)
    end

    -- 重新设置图片
    sprite.setImage = function (sprite, filename)
        local tempInfo = scale9Infos[filename]
        if tempInfo then
            sprite:setCapInsets(tempInfo.capRect)
        end
        sprite:initWithFile(filename)
        sprite:setContentSize(contentSize)
    end

    return sprite
end