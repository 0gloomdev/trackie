// This file provides backward compatibility with the old models.dart
// The actual data classes are now in database.g.dart

export '../database/database.dart'
    show
        LearningItem,
        Category,
        Tag,
        Note,
        Reminder,
        Achievement,
        UserProfile,
        DailyActivity,
        CustomDomain,
        AppSettingsTableData,
        CommunityPost,
        LearningItemsCompanion,
        CategoriesCompanion,
        TagsCompanion,
        NotesCompanion,
        RemindersCompanion,
        AchievementsCompanion,
        UserProfilesCompanion,
        DailyActivitiesCompanion,
        CustomDomainsCompanion,
        AppSettingsTableCompanion,
        CommunityPostsCompanion;

// Re-export providers if needed
export '../../features/shared/providers/drift_providers.dart';
