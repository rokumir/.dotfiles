return {
	{ -- Fun Animations
		'eandrju/cellular-automaton.nvim',
		cmd = 'CellularAutomaton',
		lazy = true,
	},

	{ -- Coding Session Timer
		'quentingruber/pomodoro.nvim',
		keys = {
			{ '<leader>p', '', desc = 'Pomodoro' },
			{ '<leader>pp', '<cmd>PomodoroStart <cr>', desc = 'Start' },
			{ '<leader>pP', '<cmd>PomodoroStop <cr>', desc = 'Stop' },
			{ '<leader>pu', '<cmd>PomodoroUI <cr>', desc = 'Display UI' },
			{ '<leader>pS', '<cmd>PomodoroSkipBreak <cr>', desc = 'Skip and start next session' },
			{ '<leader>pB', '<cmd>PomodoroForceBreak <cr>', desc = 'Forcefully start a break' },
			{ '<leader>pD', '<cmd>PomodoroDelayBreak <cr>', desc = 'Delay the current break by a delay duration' },
		},
		opts = {
			start_at_launch = true,
			work_duration = 25,
			break_duration = 5,
			snooze_duration = 1, -- The additionnal work time you get when you delay a break
		},
	},
}
