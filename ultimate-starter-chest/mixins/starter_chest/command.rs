fn perform_starter_chest(
    game: &mut crate::game::Game<'_>,
    player: &crate::game::native_server::NativeServerPlayer,
    command: &str,
    ran: &mut bool,
) {
    if command != "starterchest" {
        return;
    }

    *ran = true;

    // Plain item stacks only: Horizon API 9's helper intentionally does not
    // add enchantments, durability changes, names, or other item components.
    let supplies: [(&str, u32); 19] = [
        ("minecraft:netherite_helmet", 1),
        ("minecraft:netherite_chestplate", 1),
        ("minecraft:netherite_leggings", 1),
        ("minecraft:netherite_boots", 1),
        ("minecraft:netherite_pickaxe", 1),
        ("minecraft:netherite_shovel", 1),
        ("minecraft:elytra", 1),
        ("minecraft:totem_of_undying", 2),
        ("minecraft:golden_apple", 16),
        ("minecraft:cooked_beef", 64),
        ("minecraft:ender_pearl", 16),
        ("minecraft:water_bucket", 1),
        ("minecraft:chest", 1),
        ("minecraft:crafting_table", 1),
        ("minecraft:torch", 64),
        ("minecraft:obsidian", 32),
        ("minecraft:cobblestone", 64),
        ("minecraft:oak_planks", 64),
        ("minecraft:bread", 32),
    ];

    let mut added = 0u32;
    let mut not_added = 0u32;

    for (item, count) in supplies {
        let given = game.native_give_items(item, count).min(count);
        added += given;
        not_added += count - given;
    }

    let message = if not_added == 0 {
        format!("Starter Chest: added {added} items to your inventory.")
    } else {
        format!(
            "Starter Chest: added {added} items. {not_added} could not fit; make room and run /starterchest again."
        )
    };

    game.native_tell(
        player.uuid,
        horizon_client::text::Text::literal(message),
    );
}
