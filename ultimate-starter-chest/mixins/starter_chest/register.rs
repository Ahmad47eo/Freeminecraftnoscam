fn register_starter_chest(
    commands: &mut Vec<crate::game::native_server::NativeCommand>,
) {
    commands.push(crate::game::native_server::NativeCommand::new("starterchest"));
}
