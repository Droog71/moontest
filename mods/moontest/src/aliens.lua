--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

aliens = {}
alien_count = 0
local spawn_timer = 0

--spawns aliens
function spawn_aliens()
    spawn_timer = spawn_timer + 1
    if spawn_timer >= 500 - (450 * aggro) then
        for x = -30,30,1 do
            for z = 26,46,1 do
                if z > 33 then
                    if x < -10 or x > 10 then
                        if alien_count < (20 * (aggro - 0.2)) then
                            local chance = math.random(1,1000)
                            if chance >= 999 and minetest.get_node(vector.new(x,1,z)).name == "air" then
                                minetest.add_entity(vector.new(x,1,z), "moontest:alien")                               
                                alien_count = alien_count + 1
                            end
                        end
                    end
                else
                    if alien_count < (20 * (aggro - 0.2)) then
                        local chance = math.random(1,1000)
                        if chance >= 999 and minetest.get_node(vector.new(x,1,z)).name == "air" then
                            minetest.add_entity(vector.new(x,1,z), "moontest:alien")
                            alien_count = alien_count + 1
                        end
                    end
                end
            end
        end
        spawn_timer = 0
    end
end

--defines the alien entity
alien_definition = {
    physical = true,	
    collisionbox = {-0.49, -0.49, -0.49, 0.49, 0.49, 0.49 },
    spritediv = {x = 1, y = 1},
    initial_sprite_basepos = {x = 0, y = 0},
    visual = "upright_sprite",
    visual_size = { x = 1, y = 1 },
    textures = { "alien.png", "alien_back.png" },
    view_range = 128,
    walk_velocity = 4,
    run_velocity = 8,
    damage = 1,
    drawtype = "front",
    timer = 0,
    attack = {player=nil, dist=nil},
    state = "stand",
    v_start = false,
    
    on_punch = function(self, hitter, time_from_last_punch, tool_capabilities)
        minetest.sound_play("splat", {object = self.object})
        self.object:set_properties({textures = { "splat.png", "splat.png" }})
        minetest.after(0.1,function()
            local item = ItemStack("moontest:splat")
            hitter:get_inventory():add_item("main", item)
            local list = hitter:get_inventory():get_list("main")
            for index_1,stack_1 in pairs(list) do
                local current = hitter:get_inventory():get_stack("main", index_1):get_name()
                if current == "moontest:splat" and index_1 < 9 then
                    for index_2,stack_2 in pairs(list) do
                        if stack_2:is_empty() and index_2 > 8 then
                            local empty = ItemStack("")
                            hitter:get_inventory():set_stack("main", index_1, empty)
                            hitter:get_inventory():set_stack("main", index_2, stack_1)
                            break
                        end
                    end
                end
            end
            self.object:remove()
            alien_count = alien_count - 1
        end)
    end,
    
    jump = function (self)
        local v = self.object:get_velocity()
        v.y = 5
        self.object:set_velocity(v)
    end,

    set_velocity = function(self, v)
        local yaw = self.object:get_yaw()
        local x = math.sin(yaw) * -v
        local z = math.cos(yaw) * v
        self.object:set_velocity({x=x, y=self.object:get_velocity().y, z=z})
    end,
    
    get_velocity = function(self)
        local v = self.object:get_velocity()
        return (v.x^2 + v.z^2)^(0.5)
    end,
    
    on_step = function(self, dtime)			
        alien_step(self, dtime)
    end,
    
    on_activate = function(self, staticdata, dtime_s)
        self.object:set_acceleration({x=0, y=-10, z=0})
        self.state = "stand"
        self.attack = {player = nil, dist = nil}
        self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
        self.object:set_yaw(math.random(1, 360)/180*math.pi)
        table.insert(aliens, self.object)
    end,

    __index = function(table,key)
        return alien_definition[key]
    end
}

--updates the entity
function alien_step(self, dtime)
    apply_gravity(self)

    self.timer = self.timer + dtime
    if self.state ~= "attack" then
        if self.timer < 1 then
            return
        end
        self.timer = 0
    end

    if math.random(1, 100) <= 1 then
        minetest.sound_play("alien", {object = self.object})
    end

    look_for_player(self)

    if self.following and self.following:is_player() then
        follow_player(self)
    end
      
    update_state(self)	
    
    local node = minetest.get_node(self.object:get_pos()).name
    if node ~= "air" and string.sub(node, 0, 8) ~= "mesecons" then
        self.object:remove()
        alien_count = alien_count - 1
    end
end

--simulates gravity
function apply_gravity(self)
    if self.object:get_velocity().y > 0.1 then
        local yaw = self.object:get_yaw()
        local x = math.sin(yaw) * -2
        local z = math.cos(yaw) * 2
        self.object:set_acceleration({x=x, y=-10, z=z})
    else
        self.object:set_acceleration({x=0, y=-10, z=0})
    end
end

--finds a player to follow and attack
function look_for_player(self)
    local s = self.object:get_pos()
    for _,player in pairs(minetest.get_connected_players()) do
        local p = player:get_pos()
        local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
        if dist < self.view_range then
            if self.attack.dist then
                if dist < self.attack.dist then
                    self.attack.player = player
                    self.attack.dist = dist
                end
            else
                self.state = "attack"
                self.attack.player = player
                self.attack.dist = dist
            end
        end
    end

    if self.attack.player then
      local p = self.attack.player:get_pos()
      if not p or not s or not minetest.line_of_sight({x=s.x, y=s.y+1, z=s.z}, {x=p.x, y=p.y+1, z=p.z}) then
          self.state = "stand"
          self.attack = {player = nil, dist = nil}
      end
    end

    if self.follow and self.follow ~= "" and not self.following then
        for _,player in pairs(minetest.get_connected_players()) do
            local s = self.object:get_pos()
            local p = player:get_pos()
            local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
            if self.view_range and dist < self.view_range then
                self.following = player
            end
        end
    end
end

--follows the designated player
function follow_player(self)
    if self.following:get_wielded_item():get_name() ~= self.follow then
        self.following = nil
        self.v_start = false
    else
        local s = self.object:get_pos()
        local p = self.following:get_pos()
        local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
        if dist > self.view_range then
            self.following = nil
            self.v_start = false
        else
            local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
            local yaw = math.atan(vec.z/vec.x) + math.pi/2
            if p.x > s.x then
                yaw = yaw + math.pi
            end
            self.object:set_yaw(yaw)
            if dist > 2 then
                if not self.v_start then
                    self.v_start = true
                    self.set_velocity(self, self.walk_velocity)
                else
                    if self.jump and self.get_velocity(self) <= 0.5 and self.object:get_velocity().y == 0 then
                        self:jump()
                    end
                    self.set_velocity(self, self.walk_velocity)
                end
            else
                self.v_start = false
                self.set_velocity(self, 0)
            end
        end
    end
end

--performs state specific actions
function update_state(self)
    if self.state == "stand" then
        if math.random(1, 4) == 1 then
            self.object:set_yaw(self.object:get_yaw()+((math.random(0,360)-180)/180*math.pi))
        end
        self.set_velocity(self, 0)
        if math.random(1, 100) <= 50 then
            self.set_velocity(self, self.walk_velocity)
            self.state = "walk"
        end
    elseif self.state == "walk" then
        if math.random(1, 100) <= 30 then
            self.object:set_yaw(self.object:get_yaw()+((math.random(0,360)-180)/180*math.pi))
        end
        if self.jump and self.get_velocity(self) <= 0.5 and self.object:get_velocity().y == 0 then
            self:jump()
        end
        self.set_velocity(self, self.walk_velocity)
        if math.random(1, 100) <= 10 then
            self.set_velocity(self, 0)
            self.state = "stand"
        end
    elseif self.state == "attack" then
        do_attack_state(self)
    end
end

--attacks the player or reverts to standing state
function do_attack_state(self)
    if not self.attack.player or not self.attack.player:is_player() then
        self.state = "stand"
        self.attack = {player=nil, dist=nil}
        return
    end
    local s = self.object:get_pos()
    local p = self.attack.player:get_pos()
    local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
    if dist > self.view_range or self.attack.player:get_hp() <= 0 then
        self.state = "stand"
        self.v_start = false
        self.set_velocity(self, 0)
        self.attack = {player=nil, dist=nil}
        return
    else
        self.attack.dist = dist
    end

    local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
    local yaw = math.atan(vec.z/vec.x)+math.pi/2
    if p.x > s.x then
        yaw = yaw+math.pi
    end
    self.object:set_yaw(yaw)
    if self.attack.dist > 2 then
        if not self.v_start then
            self.v_start = true
            self.set_velocity(self, self.run_velocity)
        else
            if self.jump and self.get_velocity(self) <= 0.5 and self.object:get_velocity().y == 0 then
                self:jump()
            end
            self.set_velocity(self, self.run_velocity)
        end
    else
        self.set_velocity(self, 0)
        self.v_start = false
        if self.timer > 1 then
            self.timer = 0
            minetest.sound_play("alien_attack", {object = self.object})
            self.attack.player:punch(self.object, 1.0,  {
              full_punch_interval=1.0,
              damage_groups = {fleshy=self.damage}
            }, vec)
        end
    end
end
