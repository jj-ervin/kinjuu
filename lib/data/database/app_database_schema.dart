abstract final class AppDatabaseSchema {
  static const version = 1;

  static const createTableStatements = <String>[
    '''
    CREATE TABLE accounts (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      institution_name TEXT NOT NULL,
      account_type TEXT NOT NULL,
      masked_reference TEXT NOT NULL,
      notes TEXT NOT NULL DEFAULT '',
      is_archived INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE cards (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      issuer TEXT NOT NULL,
      card_type TEXT NOT NULL,
      masked_reference TEXT NOT NULL,
      statement_day INTEGER,
      due_day INTEGER,
      notes TEXT NOT NULL DEFAULT '',
      is_archived INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE obligations (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      obligation_type TEXT NOT NULL,
      source_type TEXT NOT NULL CHECK (source_type = 'manual'),
      linked_account_id TEXT,
      linked_card_id TEXT,
      expected_amount REAL,
      minimum_amount REAL,
      currency_code TEXT NOT NULL,
      due_date TEXT NOT NULL,
      statement_date TEXT,
      recurrence_rule TEXT NOT NULL,
      status TEXT NOT NULL,
      autopay_expected INTEGER NOT NULL DEFAULT 0,
      category TEXT NOT NULL DEFAULT '',
      notes TEXT NOT NULL DEFAULT '',
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (linked_account_id) REFERENCES accounts(id) ON DELETE SET NULL,
      FOREIGN KEY (linked_card_id) REFERENCES cards(id) ON DELETE SET NULL
    )
    ''',
    '''
    CREATE TABLE subscriptions (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      provider_name TEXT NOT NULL,
      source_type TEXT NOT NULL CHECK (source_type = 'manual'),
      billing_cycle TEXT NOT NULL,
      expected_amount REAL,
      renewal_date TEXT NOT NULL,
      linked_account_id TEXT,
      linked_card_id TEXT,
      status TEXT NOT NULL,
      notes TEXT NOT NULL DEFAULT '',
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (linked_account_id) REFERENCES accounts(id) ON DELETE SET NULL,
      FOREIGN KEY (linked_card_id) REFERENCES cards(id) ON DELETE SET NULL
    )
    ''',
    '''
    CREATE TABLE payment_events (
      id TEXT PRIMARY KEY,
      obligation_id TEXT NOT NULL,
      event_type TEXT NOT NULL,
      event_date TEXT NOT NULL,
      amount REAL,
      note TEXT,
      created_at TEXT NOT NULL,
      time_loc TEXT,
      FOREIGN KEY (obligation_id) REFERENCES obligations(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE notification_rules (
      id TEXT PRIMARY KEY,
      target_type TEXT NOT NULL,
      target_id TEXT,
      days_before INTEGER NOT NULL DEFAULT 0,
      trigger_on_due_date INTEGER NOT NULL DEFAULT 1,
      trigger_if_overdue INTEGER NOT NULL DEFAULT 0,
      overdue_interval_days INTEGER,
      is_enabled INTEGER NOT NULL DEFAULT 1,
      quiet_hours_start TEXT,
      quiet_hours_end TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE audit_entries (
      id TEXT PRIMARY KEY,
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      action_type TEXT NOT NULL,
      summary TEXT NOT NULL,
      created_at TEXT NOT NULL,
      time_loc TEXT
    )
    ''',
  ];

  static const createIndexStatements = <String>[
    'CREATE INDEX idx_obligations_due_date ON obligations(due_date)',
    'CREATE INDEX idx_obligations_status ON obligations(status)',
    'CREATE INDEX idx_subscriptions_renewal_date ON subscriptions(renewal_date)',
    'CREATE INDEX idx_payment_events_obligation_id ON payment_events(obligation_id)',
    'CREATE INDEX idx_audit_entries_created_at ON audit_entries(created_at)',
  ];
}
