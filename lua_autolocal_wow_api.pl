use strict;
use warnings;
use File::Slurp qw(read_file write_file);

my $source_file_name = shift or die "No source file name!";
my $source = read_file($source_file_name);

my %local_to_global;

my $section_name;
while ("
    -- Lua
    _G
    local concat = table.concat
    local format = string.format
    local gsub = string.gsub
    local match = string.match
    local random = math.random
    local sfind = string.find
    local strbyte = string.byte
    local strchar = string.char
    local string_sub = string.sub
    local tconcat = table.concat
    local tinsert = table.insert
    local tremove = table.remove
    local tsort = table.sort
    next
    pairs
    print
    setfenv
    setmetatable
    tonumber
    tostring
    type
    unpack

    -- Blizzard global
    local dump = DevTools_Dump
    ARTIFACT_POWER
    ATTACHMENTS_MAX_RECEIVE
    BACKPACK_CONTAINER
    BANK_CONTAINER
    C_Garrison
    C_LFGList
    CANCEL
    ChatEdit_ActivateChat
    CheckInteractDistance
    CLASS_SORT_ORDER
    CreateFrame
    FONT_COLOR_CODE_CLOSE
    GARRISON_CURRENCY
    GARRISON_FOLLOWER_IN_PARTY
    GARRISON_FOLLOWER_MAX_LEVEL
    GARRISON_FOLLOWER_ON_MISSION
    GARRISON_FOLLOWER_ON_MISSION_WITH_DURATION
    GARRISON_FOLLOWER_WORKING
    GARRISON_SHIP_OIL_CURRENCY
    GetContainerItemID
    GetContainerItemInfo
    GetContainerNumSlots
    GetFlyoutInfo
    GetFramesRegisteredForEvent
    GetHaste
    GetInboxNumItems
    GetInstanceInfo
    GetInventoryItemID
    GetInventorySlotInfo
    GetItemCooldown
    GetItemInfo
    GetItemInfoInstant
    GetLFGDungeonEncounterInfo
    GetLFGDungeonNumEncounters
    GetNumGroupMembers
    GetNumPartyMembers
    GetNumSpellTabs
    GetQuestDifficultyColor
    GetShapeshiftForm
    GetSpecialization
    GetSpellBonusDamage
    GetSpellBookItemInfo
    GetSpellBookItemInfo
    GetSpellBookItemName
    GetSpellCooldown
    GetSpellCritChance
    GetSpellInfo
    GetSpellTabInfo
    GetTime
    GetUnitSpeed
    GREEN_FONT_COLOR_CODE
    HasCursorItem
    HybridScrollFrame_GetOffset
    InCombatLockdown
    INVSLOT_MAINHAND
    IsControlKeyDown
    IsEquippedItem
    IsFalling
    IsIndoors
    IsInInstance
    IsInRaid
    IsItemInRange
    IsMounted
    IsQuestFlaggedCompleted
    IsShiftKeyDown
    IsSpellInRange
    IsSpellKnown
    IsSubmerged
    IsSwimming
    IsUsableSpell
    ItemLocation
    ITEM_QUALITY_COLORS
    ITEM_SOULBOUND
    ITEM_SPELL_KNOWN
    ITEM_SPELL_TRIGGER_ONUSE
    LE_ITEM_BIND_NONE
    LE_ITEM_BIND_ON_ACQUIRE
    LE_ITEM_BIND_ON_EQUIP
    LE_ITEM_BIND_ON_USE
    LE_ITEM_BIND_QUEST
    LE_ITEM_CLASS_CONSUMABLE
    LoadAddOn
    MAX_CLASSES
    NUM_BAG_SLOTS
    NUM_BANKBAGSLOTS
    NUM_LE_ITEM_BIND_TYPES
    ORANGE_FONT_COLOR_CODE
    PickupContainerItem
    PlaySound
    random
    REAGENTBANK_CONTAINER
    RED_FONT_COLOR_CODE
    SecureHandlerWrapScript
    SocketInventoryItem
    SpellHasRange
    SplitContainerItem
    strfind
    strsub
    TakeInboxItem
    UIParent
    UIParent_OnEvent
    UnitAffectingCombat
    UnitAttackPower
    UnitAura
    UnitBuff
    UnitCanAssist
    UnitCanAttack
    UnitCastingInfo
    UnitChannelInfo
    UnitClassification
    UnitDebuff
    UnitExists
    UnitGroupRolesAssigned
    UnitGUID
    UnitHealth
    UnitHealthMax
    UnitIsDead
    UnitIsDeadOrGhost
    UnitIsPlayer
    UnitIsUnit
    UnitLevel
    UnitName
    UnitPower
    UnitThreatSituation
    unpack
    UseContainerItem
    wipe
    WorldFrame

    -- Blizzard global frames/Lua - addons
    GarrisonLandingPage
    GarrisonMission_GetDurationStringCompact
    GarrisonMissionFrame
    GarrisonRecruitSelectFrame

    -- Blizzard C_Garrison
    AddFollowerToMission = C_Garrison.AddFollowerToMission
    AssignFollowerToBuilding = C_Garrison.AssignFollowerToBuilding
    CastSpellOnFollower = C_Garrison.CastSpellOnFollower
    GetFollowerAbilities = C_Garrison.GetFollowerAbilities
    GetFollowerInfo = C_Garrison.GetFollowerInfo
    GetFollowerInfoForBuilding = C_Garrison.GetFollowerInfoForBuilding
    GetFollowerItems = C_Garrison.GetFollowerItems
    GetFollowerMissionTimeLeft = C_Garrison.GetFollowerMissionTimeLeft
    GetFollowerMissionTimeLeftSeconds = C_Garrison.GetFollowerMissionTimeLeftSeconds
    GetFollowers = C_Garrison.GetFollowers
    GetFollowerSoftCap = C_Garrison.GetFollowerSoftCap
    GetFollowerStatus = C_Garrison.GetFollowerStatus
    GetLandingPageShipmentInfo = C_Garrison.GetLandingPageShipmentInfo
    GetMissionCost = C_Garrison.GetMissionCost
    GetNumActiveFollowers = C_Garrison.GetNumActiveFollowers
    GetNumFollowersOnMission = C_Garrison.GetNumFollowersOnMission
    GetPartyMissionInfo = C_Garrison.GetPartyMissionInfo
    RemoveFollowerFromBuilding = C_Garrison.RemoveFollowerFromBuilding
    RemoveFollowerFromMission = C_Garrison.RemoveFollowerFromMission

    -- Blizzard C_Timer
    After = C_Timer.After
    CTimerAfter = C_Timer.After

    -- Blizzard C_Map
    C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit

    -- Blizzard C_MountJournal
    GetMountInfo = C_MountJournal.GetMountInfo
    GetMountInfoExtra = C_MountJournal.GetMountInfoExtra
    GetNumMounts = C_MountJournal.GetNumMounts
    GetDisplayedMountInfo = C_MountJournal.GetDisplayedMountInfo
    GetMountInfoExtraByID = C_MountJournal.GetMountInfoExtraByID
    GetNumDisplayedMounts = C_MountJournal.GetNumDisplayedMounts
    GetMountIDs = C_MountJournal.GetMountIDs
    GetMountInfoByID = C_MountJournal.GetMountInfoByID
    GetMountInfoExtraByID = C_MountJournal.GetMountInfoExtraByID

    -- Blizzard C_ArtifactUI
    C_ArtifactUI_Clear = C_ArtifactUI.Clear
    C_ArtifactUI_GetArtifactInfo = C_ArtifactUI.GetArtifactInfo
    C_ArtifactUI_GetPowerInfo = C_ArtifactUI.GetPowerInfo
    C_ArtifactUI_GetPowers = C_ArtifactUI.GetPowers

    -- Blizzard C_AzeriteEmpoweredItem
    C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem
    C_AzeriteEmpoweredItem_GetAllTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo
    C_AzeriteEmpoweredItem_IsPowerSelected = C_AzeriteEmpoweredItem.IsPowerSelected

    -- Blizzard SOUNDKIT
    SOUNDKIT_GS_TITLE_OPTION_OK = SOUNDKIT.GS_TITLE_OPTION_OK
    SOUNDKIT_UI_GARRISON_COMMAND_TABLE_ASSIGN_FOLLOWER = SOUNDKIT.UI_GARRISON_COMMAND_TABLE_ASSIGN_FOLLOWER
    SOUNDKIT_UI_GARRISON_COMMAND_TABLE_UNASSIGN_FOLLOWER = SOUNDKIT.UI_GARRISON_COMMAND_TABLE_UNASSIGN_FOLLOWER

    -- Blizzard C_CurrencyInfo
    GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo

    -- Blizzard Enum w/ legacy
    LE_FOLLOWER_TYPE_GARRISON_6_0 = Enum.GarrisonFollowerType.FollowerType_6_0
    LE_FOLLOWER_TYPE_GARRISON_7_0 = Enum.GarrisonFollowerType.FollowerType_7_0
    LE_FOLLOWER_TYPE_GARRISON_8_0 = Enum.GarrisonFollowerType.FollowerType_8_0
    LE_FOLLOWER_TYPE_SHIPYARD_6_2 = Enum.GarrisonFollowerType.FollowerType_6_2
    LE_GARRISON_TYPE_6_0 = Enum.GarrisonType.Type_6_0

" =~ /([^\r\n]+)/g) {
    my $line = $1;
    $line =~ s/^\s+//;
    # print "*** $line\n";
    if ($line =~ /^-- (.+)/) {
        $section_name = $1;
    } elsif ($line =~ /^(.+) = (.+)$/) {
        my ($local, $global) = ($1, $2);
        $local =~ s/^local //;
        $local_to_global{$local} = $global;
    } elsif ($line =~ /^(\w+)$/) {
        $local_to_global{$1} = $1;
    }
}

$source =~ s/^(-- \[AUTOLOCAL START\].*?)$(.*)^(-- \[AUTOLOCAL END\].*?)$/$1\n\n$3/ms;

my %locals_found;
while (my ($local, $global) = each(%local_to_global)) {
    # print "$local -> $global\n";
    if ($source =~ /\b$local\b/) { $locals_found{$local}++ }
}

if ($locals_found{setfenv}) { $locals_found{_G}++ }

my $locals;
foreach my $local (sort keys %locals_found) {
    if ($locals) { $locals .= "\n" }
    $locals .= "local $local = $local_to_global{$local}"
}

# -- [AUTOLOCAL START] -- [AUTOLOCAL END]
$source =~ s/^(-- \[AUTOLOCAL START\].*?)$(.*)^(-- \[AUTOLOCAL END\].*?)$/$1\n$locals\n$3/ms;
write_file("$source_file_name.new", $source);
