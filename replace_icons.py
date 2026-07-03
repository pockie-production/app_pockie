import os
import glob

replacements = {
    'Icons.arrow_back': 'CupertinoIcons.back',
    'Icons.add': 'CupertinoIcons.add',
    'Icons.send_rounded': 'CupertinoIcons.paperplane_fill',
    'Icons.bolt': 'CupertinoIcons.bolt_fill',
    'Icons.photo_library_outlined': 'CupertinoIcons.photo',
    'Icons.help_outline': 'CupertinoIcons.question_circle',
    'Icons.attach_money': 'CupertinoIcons.money_dollar',
    'Icons.swap_horiz': 'CupertinoIcons.arrow_right_arrow_left',
    'Icons.category_outlined': 'CupertinoIcons.square_grid_2x2',
    'Icons.note_alt_outlined': 'CupertinoIcons.doc_text',
    'Icons.visibility_off_outlined': 'CupertinoIcons.eye_slash',
    'Icons.visibility_outlined': 'CupertinoIcons.eye',
    'Icons.person': 'CupertinoIcons.person_solid',
    'Icons.person_outline': 'CupertinoIcons.person',
    'Icons.save_outlined': 'CupertinoIcons.floppy_disk',
    'Icons.vpn_key_outlined': 'CupertinoIcons.key',
    'Icons.lock_outline': 'CupertinoIcons.lock',
    'Icons.notifications_none': 'CupertinoIcons.bell',
    'Icons.trending_up': 'CupertinoIcons.graph_square',
    'Icons.monetization_on_outlined': 'CupertinoIcons.money_dollar_circle',
    'Icons.keyboard_arrow_down': 'CupertinoIcons.chevron_down',
    'Icons.auto_awesome': 'CupertinoIcons.sparkles',
    'Icons.chevron_right': 'CupertinoIcons.chevron_right',
    'Icons.receipt_long': 'CupertinoIcons.doc_plaintext',
    'Icons.home_outlined': 'CupertinoIcons.home',
    'Icons.account_balance_wallet_outlined': 'CupertinoIcons.creditcard',
    'Icons.card_giftcard': 'CupertinoIcons.gift',
    'Icons.pie_chart_outline': 'CupertinoIcons.chart_pie',
    'Icons.arrow_downward': 'CupertinoIcons.arrow_down',
    'Icons.star': 'CupertinoIcons.star_fill',
    'Icons.star_border': 'CupertinoIcons.star',
    'Icons.payments_outlined': 'CupertinoIcons.money_dollar_circle',
    'Icons.push_pin': 'CupertinoIcons.pin_fill',
    'Icons.confirmation_number_outlined': 'CupertinoIcons.ticket',
    'Icons.access_time': 'CupertinoIcons.clock',
    'Icons.local_offer_outlined': 'CupertinoIcons.tag',
    'Icons.chat_bubble_outline': 'CupertinoIcons.chat_bubble',
    'Icons.calendar_today_outlined': 'CupertinoIcons.calendar',
    'Icons.logout': 'CupertinoIcons.square_arrow_right',
}

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
        
    original_content = content
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    if content != original_content:
        # Check if cupertino is imported
        if "package:flutter/cupertino.dart" not in content:
            # add it after material.dart
            if "import 'package:flutter/material.dart';" in content:
                content = content.replace(
                    "import 'package:flutter/material.dart';",
                    "import 'package:flutter/material.dart';\nimport 'package:flutter/cupertino.dart';"
                )
            else:
                # just prepend it
                content = "import 'package:flutter/cupertino.dart';\n" + content
                
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Updated {filepath}")

dart_files = glob.glob('lib/**/*.dart', recursive=True)
for file in dart_files:
    process_file(file)
