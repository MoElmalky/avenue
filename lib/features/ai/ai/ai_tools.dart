class AiTools {
  static List<Map<String, dynamic>> get declarations => [
    {
      'name': 'getSchedule',
      'description':
          'Fetch schedule for a specific date or date range. This is the PRIMARY tool for all time-based questions. Returns both normal tasks and recurring habits/default tasks by default. Past dates only return normal tasks.',
      'parameters': {
        'type': 'OBJECT',
        'properties': {
          'startDate': {
            'type': 'STRING',
            'description': 'The start date in YYYY-MM-DD format.',
          },
          'endDate': {
            'type': 'STRING',
            'description': 'Optional end date for ranges in YYYY-MM-DD format.',
          },
          'type': {
            'type': 'STRING',
            'enum': ['all', 'task', 'default'],
            'description':
                'Filter by type: "all" (default), "task" (non-recurring), or "default" (habits/recurring).',
          },
        },
        'required': ['startDate'],
      },
    },
    {
      'name': 'searchSchedule',
      'description':
          'Semantic search for tasks or habits by topic, name, or meaning. Use this when the user asks about a specific activity without specifying a date.',
      'parameters': {
        'type': 'OBJECT',
        'properties': {
          'query': {
            'type': 'STRING',
            'description': 'The search query or topic.',
          },
          'type': {
            'type': 'STRING',
            'enum': ['all', 'task', 'default'],
            'description':
                'Filter by type: "all" (default), "task" (non-recurring), or "default" (habits/recurring).',
          },
        },
        'required': ['query'],
      },
    },
    {
      'name': 'manageSchedule',
      'description':
          'Unified tool to create or update one-time tasks and recurring habits. Use this for ALL modifications to the schedule.',
      'parameters': {
        'type': 'OBJECT',
        'properties': {
          'action': {
            'type': 'STRING',
            'enum': ['create', 'update'],
            'description':
                'Whether to create a new entry or update an existing one.',
          },
          'type': {
            'type': 'STRING',
            'enum': ['task', 'default'],
            'description':
                '"task" for one-time entries, "default" for recurring habits.',
          },
          'id': {
            'type': 'STRING',
            'description': 'Required ONLY for "update" action.',
          },
          'name': {'type': 'STRING'},
          'date': {
            'type': 'STRING',
            'description': 'YYYY-MM-DD (Required for type="task").',
          },
          'startTime': {
            'type': 'STRING',
            'description': 'HH:mm (Required for create).',
          },
          'endTime': {'type': 'STRING', 'description': 'HH:mm.'},
          'weekdays': {
            'type': 'ARRAY',
            'items': {'type': 'INTEGER'},
            'description':
                '1=Mon, 7=Sun (Required for create where type="default").',
          },
          'importance': {
            'type': 'STRING',
            'enum': ['Low', 'Medium', 'High'],
          },
          'note': {'type': 'STRING'},
          'category': {
            'type': 'STRING',
            'enum': ['Work', 'Meeting', 'Personal', 'Health', 'Other'],
          },
          'isDone': {'type': 'BOOLEAN', 'description': 'Only for type="task".'},
          'isDeleted': {
            'type': 'BOOLEAN',
            'description': 'Set to true to delete the task or habit.',
          },
        },
        'required': ['action', 'type'],
      },
    },
  ];
}
