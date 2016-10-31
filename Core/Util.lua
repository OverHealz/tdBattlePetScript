--[[
Api.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns   = select(2, ...)
local Util = {} ns.Util = Util

local function comparePet(owner, index, pet)
    return pet == C_PetBattles.GetName(owner, index) or tonumber(pet) == C_PetBattles.GetPetSpeciesID(owner, index)
end

function Util.ParseIndex(value)
    return type(value) == 'string' and tonumber(value:match('^#(%d+)$')) or nil
end

function Util.ParsePetOwner(owner)
    return  owner == 'self'  and LE_BATTLE_PET_ALLY  or
            owner == 'ally'  and LE_BATTLE_PET_ALLY  or
            owner == 'enemy' and LE_BATTLE_PET_ENEMY or nil
end

function Util.ParsePetIndex(owner, pet)
    if not owner then
        return
    end
    if not pet then
        return C_PetBattles.GetActivePet(owner)
    end
    local index = Util.ParseIndex(pet)
    if index then
        if index >= 1 and index <= C_PetBattles.GetNumPets(owner) then
            return index
        end
    else
        local active = C_PetBattles.GetActivePet(owner)
        if comparePet(owner, active, pet) then
            return active
        end
        for i = 1, C_PetBattles.GetNumPets(owner) do
            if comparePet(owner, i, pet) then
                return i
            end
        end
    end
end

function Util.ParseAbility(owner, pet, ability)
    local index = Util.ParseIndex(ability)
    if index then
        if index and index >= 1 and index <= NUM_BATTLE_PET_ABILITIES then
            return index
        end
    else
        for i = 1, NUM_BATTLE_PET_ABILITIES do
            local id, name = C_PetBattles.GetAbilityInfo(owner, pet, i)
            if id == tonumber(ability) or name == ability then
                return i
            end
        end
    end
end

function Util.FindAura(owner, pet, aura)
    for i = 1, C_PetBattles.GetNumAuras(owner, pet) do
        local id, name = C_PetBattles.GetAbilityInfoByID(C_PetBattles.GetAuraInfo(owner, pet, i))
        if id == aura or name == aura then
            return i
        end
    end
end

function Util.assert(flag, formatter, ...)
    if not flag then
        error(format(formatter, ...), 0)
    end
end