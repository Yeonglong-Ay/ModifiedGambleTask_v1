# Gamble Task — Overton-style task + Ay modifications

Implements a trial-by-trial gambling task where participants choose between:
- Safe option: $10
- Gamble option: $15–$30

Each trial shows a probability cue (integer 0–10). After choice, a second integer is revealed 550ms post-choice; gamble wins if second > first (no ties). Left/right location of safe vs gamble is randomized. Inter-trial interval is 1s.

Additionally, the task supports 3 interleaved block types:
- Neutral: no enforced streaks
- Loss-heavy: enforced loss streaks (length 4–6 on gamble-chosen trials)
- Win-heavy: enforced win streaks (length 4–6 on gamble-chosen trials)

Streak enforcement is preferentially applied on win-probability=50% trials to preserve a naturalistic experience, while other probabilities are used to balance exposure across blocks.

## Requirements
- MATLAB R2019b+ recommended
- Psychtoolbox-3 installed and on MATLAB path

## Quick start
1. Open MATLAB
2. `cd` into repo
3. Run:
   ```matlab
   addpath(genpath('src'));
   main_gambletask
## Repo Layout
ModifiedGambleTask_v1/
  README.md
  LICENSE
  .gitignore
  requirements.md
  config/
    default_params.json
  src/
    main_gambletask.m
    load_params.m
    init_ptb.m
    run_experiment.m
    make_design.m
    run_block.m
    run_trial.m
    enforce_streak_logic.m
    compute_winprob_from_cue.m
    sample_gamble_amount.m
    draw_trial_screen.m
    draw_fixation.m
    draw_outcome_screen.m
    collect_choice.m
    log_event.m
    save_data.m
    utils/
      jsondecode_safe.m
  data/            (created at runtime; ignored by git)
  docs/
    task_timing.md
