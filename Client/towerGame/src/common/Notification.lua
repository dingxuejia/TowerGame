--[[
    文件名：Notification.lua
    描述：自定义消息分发类，用于控制控件数据的自动更新
    创建人：dingxuejia
    创建时间：2016.12.7
--]]

-- 消息通知类
Notification = {
    -- 消息通知保存
    _notifyTable = {},
    _snotifyTable = {}
}

--[[
    params:
    node: 绑定的结点, 不能设置为Layer中的self变量
    notifyFunc: 事件回调函数
    nameList: 事件名或者是事件列表
--]]
function Notification:register(node, notifyFunc, nameList)
    local function registerOne(name)
        --查找是否存在此name
        if not self._notifyTable[name] then
            self._notifyTable[name] = {}
        end

        -- 不能对相同node注册相同的事件
        for i,v in ipairs(self._notifyTable[name]) do
            if v.node == node then
                return
            end
        end
        table.insert(self._notifyTable[name], {node=node, func=notifyFunc})

        -- if name == Player.Events.eGoddoMainTeam then
        --     dump(self._notifyTable[name],"注册列表")
        -- end
    end

    if type(nameList) == "table" then
        for _, name in ipairs(nameList) do
            registerOne(name)
        end
    else
        registerOne(nameList)
    end

    -- 添加自动删除事件
    node:registerScriptHandler(function(eventType)
        if eventType == "exit" then
            if type(nameList) == "table" then
                for _, name in ipairs(nameList) do
                    self:unregister(node, name)
                end
            else
                self:unregister(node, nameList)
            end
        end
    end)
end

function Notification:unregister(node, name)
    if self._notifyTable[name] then
        -- 移除事件对应的node
        for i,v in ipairs(self._notifyTable[name]) do
            if node == v.node then
                table.remove(self._notifyTable[name], i)
                break
            end
        end
    end
end

function Notification:post(name, data)

    -- if name == Player.Events.eGoddoMainTeam then

    --     dump(self._notifyTable[name],"发送列表")

    -- end

    if self._notifyTable[name] then
        -- 调用注册的函数
        for i,v in ipairs(self._notifyTable[name]) do
            if not tolua.isnull(v.node) then
                v.func(v.node, data)
            end
        end
    end
end

--不绑定Node，单纯的事件通知
function Notification:simRegister(notifyFunc, nameList)
    if type(nameList) == "table" then
        for _, name in ipairs(nameList) do
            self._snotifyTable[name].func = notifyFunc
        end
    else
        self._snotifyTable[nameList].func = notifyFunc
    end
end

function Notification:simUnRegister(name)
    if self._snotifyTable[name] then self._snotifyTable[name] = nil end
end

function Notification:simPost(name, data)
    if self._snotifyTable[name] then self._snotifyTable[name].func(data) end
end

function Notification:clean()
    -- 清空所有通知消息
    self._notifyTable = {}
    self._snotifyTable = {}
end