using System;

namespace Monitoring
{
    /// <summary>
    /// The comparison types a limit operator can perform.
    /// </summary>
    public enum LimitOperator
    {
        /// <summary>
        /// 
        /// </summary>
        GreaterThan,
        /// <summary>
        /// 
        /// </summary>
        GreaterEqual,
        /// <summary>
        /// 
        /// </summary>
        Equal,
        /// <summary>
        /// 
        /// </summary>
        NotEqual,
        /// <summary>
        /// 
        /// </summary>
        LessEqual,
        /// <summary>
        /// 
        /// </summary>
        LessThan,
        /// <summary>
        /// 
        /// </summary>
        Like,
        /// <summary>
        /// 
        /// </summary>
        NotLike,
        /// <summary>
        /// 
        /// </summary>
        Match,
        /// <summary>
        /// 
        /// </summary>
        NotMatch
    }
}
