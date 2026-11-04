--.name Bloom
--.description Change Bloom
--.author pxnch

local cfg_items = {
  master = gui.add_checkbox( "Override bloom", "visuals>misc>various" ),
  bloom_scale = gui.add_slider( "Bloom scale", "visuals>misc>various", 0, 50, 1 )
}

local menu_refs = {
  remove_post_processing = gui.get_config_item( "visuals>misc>various>Disable post-processing" )
}

function on_frame_stage_notify( stage, pre_original )
  if( stage == csgo.frame_render_start and pre_original ) then
    local bloom_scale = cfg_items.bloom_scale:get_int( )

    entities.for_each( function( entity )
      if( entity:get_class( ) == "CEnvTonemapController" ) then
        entity:set_prop( "m_bUseCustomBloomScale", 0, cfg_items.master:get_bool( ) )
        entity:set_prop( "m_flCustomBloomScale", 0, bloom_scale )
      end
    end )

    if( cfg_items.master:get_bool( ) and menu_refs.remove_post_processing:get_bool( ) ) then
      utils.error_print( "Bloom can't be used if \"Post-processing\" is disabled!" )
      cfg_items.master:set_bool( false )
    end
  end
end

function on_paint( )
  gui.set_visible( "visuals>misc>various>Bloom scale", cfg_items.master:get_bool( ) )
end