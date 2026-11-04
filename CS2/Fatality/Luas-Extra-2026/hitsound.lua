function on_shot_registered(shot)
    if shot.server_damage <= 0 then return end
    engine.exec("awp.wav")
end