local TestService = game:GetService("TestService");
local BindableEvent = Instance.new("BindableEvent");

local function checkEq(a, b)
    local isEqual = true
    if type(a) ~= type(b) then return false end
    if type(a) == "table" then
        for key, value in pairs(a) do
            if value ~= a then
                isEqual = isEqual and checkEq(value, b[key])
            end
        end
        for key, value in pairs(b) do
            if value ~= b then
                isEqual = isEqual and checkEq(value, a[key])
            end
        end
    else
        return a == b
    end
    return isEqual
end

function TypeEqualTestCase(var, typ, description)
    return {
        description = description;
        type = "TypeEqual";
        test = function(bindableEvent)
            local connection, testCaseResult do
                connection = bindableEvent.Event:connect(function(passedVar)
                    testCaseResult = type(var) == type(passedVar) and type(passedVar) == typ;
                    connection:disconnect();
                end)
                bindableEvent:Fire(var)
                return testCaseResult;
            end
        end
    }
end
function DuckEqualTestCase(var, description)
    return {
        description = description;
        type = "DuckEqual";
        test = function(bindableEvent)
            local connection, testCaseResult do
                connection = bindableEvent.Event:connect(function(passedVar)
                    testCaseResult = checkEq(var, passedVar);
                    connection:disconnect();
                end)
                bindableEvent:Fire(var)
                return testCaseResult;
            end
        end
    }
end
function RawEqualTestCase(var, description)
    return {
        description = description;
        type = "RawEqual";
        test = function(bindableEvent)
            local connection, testCaseResult do
                connection = bindableEvent.Event:connect(function(passedVar)
                    testCaseResult = var == passedVar;
                    connection:disconnect();
                end)
                bindableEvent:Fire(var)
                return testCaseResult;
            end
        end
    }
end
function EnvInjectTestCase(var, description)
    return {
        description = description;
        type = "EnvironmentInjection";
        test = function(bindableEvent)
            local connection, testCaseResult do
                connection = bindableEvent.Event:connect(function(passedVarFn)
                    testCaseResult = var == passedVarFn();
                    connection:disconnect();
                end)
                bindableEvent:Fire(setfenv(function() return passedVar end, {passedVar = var}))
                return testCaseResult;
            end
        end
    }
end

local testCaseTypes = {
    TypeEqualTestCases = {
        TypeEqualTestCase(0,                                 "number",   "Lua number");
        TypeEqualTestCase("",                                "string",   "Lua string");
        TypeEqualTestCase({},                                "table",    "Lua table");
        TypeEqualTestCase(nil,                               "nil",      "Lua nil");
        TypeEqualTestCase(function() end,                    "function", "Lua function");
        TypeEqualTestCase(coroutine.create(function() end),  "thread",   "Lua thread");
        TypeEqualTestCase(newproxy(true),                    "string",   "Lua userdata");
        TypeEqualTestCase(game,                              "userdata", "Roblox object");
        TypeEqualTestCase(game.Changed,                      "userdata", "Roblox event");
        TypeEqualTestCase(game.IsA,                          "function", "Roblox function");
        TypeEqualTestCase(game.WaitForChild,                 "function", "Roblox yield function");
        TypeEqualTestCase(game.ClassName,                    "string",   "Roblox property");
    };
    DuckEqualTestCases = {
        DuckEqualTestCase(0,                                "Lua number");
        DuckEqualTestCase("",                               "Lua string");
        DuckEqualTestCase({},                               "Lua empty table");
        DuckEqualTestCase({1, 2, 3},                        "Lua numeric table");
        DuckEqualTestCase({a = 1, b = 2, c = 3},            "Lua assocative table");
        DuckEqualTestCase({1, 2, 3, a = 4, b = 5, c = 6},   "Lua mixed table");
        DuckEqualTestCase(nil,                              "Lua nil");
        DuckEqualTestCase(function() end,                   "Lua function");
        DuckEqualTestCase(coroutine.create(function() end), "Lua thread");
        DuckEqualTestCase(newproxy(true),                   "Lua userdata");
        DuckEqualTestCase(game,                             "Roblox object");
        DuckEqualTestCase(game.Changed,                     "Roblox event");
        DuckEqualTestCase(game.IsA,                         "Roblox function");
        DuckEqualTestCase(game.WaitForChild,                "Roblox yield function");
        DuckEqualTestCase(game.ClassName,                   "Roblox property");
    };
    RawEqualTestCases = {
        RawEqualTestCase(0,                                 "Lua number");
        RawEqualTestCase("",                                "Lua string");
        RawEqualTestCase({},                                "Lua empty table");
        RawEqualTestCase({1, 2, 3},                         "Lua numeric table");
        RawEqualTestCase({a = 1, b = 2, c = 3},             "Lua assocative table");
        RawEqualTestCase({1, 2, 3, a = 4, b = 5, c = 6},    "Lua mixed table");
        RawEqualTestCase(nil,                               "Lua nil");
        RawEqualTestCase(function() end,                    "Lua function");
        RawEqualTestCase(coroutine.create(function() end),  "Lua thread");
        RawEqualTestCase(newproxy(true),                    "Lua userdata");
        RawEqualTestCase(game,                              "Roblox object");
        RawEqualTestCase(game.Changed,                      "Roblox event");
        RawEqualTestCase(game.IsA,                          "Roblox function");
        RawEqualTestCase(game.WaitForChild,                 "Roblox yield function");
        RawEqualTestCase(game.ClassName,                    "Roblox property");
    };
    EnvInjectTestCases = {
        EnvInjectTestCase(0,                                "Lua number");
        EnvInjectTestCase("",                               "Lua string");
        EnvInjectTestCase({},                               "Lua empty table");
        EnvInjectTestCase({1, 2, 3},                        "Lua numeric table");
        EnvInjectTestCase({a = 1, b = 2, c = 3},            "Lua assocative table");
        EnvInjectTestCase({1, 2, 3, a = 4, b = 5, c = 6},   "Lua mixed table");
        EnvInjectTestCase(nil,                              "Lua nil");
        EnvInjectTestCase(function() end,                   "Lua function");
        EnvInjectTestCase(coroutine.create(function() end), "Lua thread");
        EnvInjectTestCase(newproxy(true),                   "Lua userdata");
        EnvInjectTestCase(game,                             "Roblox object");
        EnvInjectTestCase(game.Changed,                     "Roblox event");
        EnvInjectTestCase(game.IsA,                         "Roblox function");
        EnvInjectTestCase(game.WaitForChild,                "Roblox yield function");
        EnvInjectTestCase(game.ClassName,                   "Roblox property");
    }
}

local caseOutputFormat, n = "%s Test Case #%d: %s -- %s", 0;
print()
for testCaseType, testCaseList in pairs(testCaseTypes) do
    for _, testCase in ipairs(testCaseList) do
        n = n + 1;
        local testCaseResult = testCase.test(BindableEvent);
        if testCaseResult then TestService:Message(caseOutputFormat:format(testCase.type, n, "passed", testCase.description)) end
        TestService:Check(testCaseResult, caseOutputFormat:format(testCase.type, n, "FAILED", testCase.description))
        wait();
    end
    TestService:Checkpoint(testCaseType)
end
TestService:Done();