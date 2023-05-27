Function update_attachment_pre(process_id);
Begin
	if(!exists(process_id.attached_to))
		signal(process_id, s_kill);
		return;
	end
	
	process_id._attached_x = process_id.attached_to.x;
	process_id._attached_y = process_id.attached_to.y;
	process_id.x += process_id.attached_to.x;
	process_id.y += process_id.attached_to.y;
End

Function update_attachment_post(process_id);
Begin
	if(!exists(process_id.attached_to))
		signal(process_id, s_kill);
		return;
	end
	
	process_id.x -= process_id._attached_x;
	process_id.y -= process_id._attached_y;
End