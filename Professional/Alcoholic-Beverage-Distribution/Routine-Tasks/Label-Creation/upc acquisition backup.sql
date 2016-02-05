select t_item_master.item_number, t_item_master.upc, t_fwd_pick.location_id from t_item_master inner join t_fwd_pick on
t_item_master.item_number = t_fwd_pick.item_number where ((t_fwd_pick.location_id like 'A%') or (t_fwd_pick.location_id like 'B%' ))
