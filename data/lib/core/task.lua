Task = {}
Task.__index = Task

setmetatable(Task, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Task.new(taskID)
  local self = setmetatable({}, Task)

  self._taskID = taskID
  self._task = TASKSYS.TASKS[self._taskID]

  return self
end

function Task:getID()
  return self._taskID
end

function Task:getTask()
  return TASKSYS.TASKS[self._taskID]
end

function Task:getTempStorage()
  if TASKSYS.TASKS_TEMP_STORAGE[self._taskID] == nil then
    TASKSYS.TASKS_TEMP_STORAGE[self._taskID] = TASKSYS.TASKS_TEMP_STORAGE_TEMPLATE()
  end

  return TASKSYS.TASKS_TEMP_STORAGE[self._taskID]
end

function Task:despawnMonsters()
  if self._task.teleportSettings.monsters ~= nil then
    local tempStorage = self:getTempStorage()

    for idx, monsterUID in pairs(tempStorage.monsterUIDs) do
      local monster = Creature(monsterUID)

      monster:remove()
    end

    tempStorage.monsterUIDs = {}

    return true
  end

  return false
end
